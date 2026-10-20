require 'minitest/autorun'
require 'yaml'
require 'open3'
require 'tmpdir'
require 'fileutils'

class DevHelmBootstrapTest < Minitest::Test
  ROOT = File.expand_path('../..', __dir__)
  WORKFLOW = YAML.load_file(File.join(ROOT, '.github/workflows/terragrunt_create_dev_environment.yml'))
  SCRIPT = File.join(ROOT, '.github/scripts/apply_dev_manifests.sh')

  def deployment
    WORKFLOW.fetch('jobs').fetch('deploy-application')
  end

  def test_authentication_order_and_failure_handling
    steps = deployment.fetch('steps')
    selected = ['Login to Amazon ECR Public', 'Apply Manifests', 'Apply Manifests Take 2'].map do |name|
      steps.index { |step| step['name'] == name }
    end
    assert_equal selected.sort, selected
    selected.each do |index|
      step = steps.fetch(index)
      refute step['continue-on-error']
      assert_match(/\Anick-fields\/retry@[0-9a-f]{40}\z/, step.fetch('uses'))
      assert_operator step.fetch('with').fetch('max_attempts'), :>, 1
      assert_operator step.fetch('with').fetch('timeout_seconds'), :>, 0
    end
    assert_operator deployment.fetch('timeout-minutes'), :<, 60
    command = steps.fetch(selected.first).fetch('with').fetch('command')
    assert_includes command, 'get-login-password --region us-east-1'
    assert_includes command, 'helm registry login --username AWS --password-stdin public.ecr.aws'
    [[0, 0], [23, 0], [0, 24]].each do |aws_exit, helm_exit|
      mock = "aws() { return #{aws_exit}; }; helm() { return #{helm_exit}; };\n"
      stdout, _stderr, result = Open3.capture3('bash', '-c', mock + command + "\nprintf REACHED_APPLY\n")
      assert_equal aws_exit.zero? && helm_exit.zero?, result.success?
      assert_equal result.success?, stdout.include?('REACHED_APPLY')
    end
  end

  def test_manifest_commit_is_pinned
    assert_equal '${{ needs.resolve-dev-manifests.outputs.ref }}', deployment.fetch('env').fetch('MANIFESTS_REF')
    checkout = deployment.fetch('steps').find { |step| step['name'] == 'Checkout pinned manifests' }
    assert_equal '${{ needs.resolve-dev-manifests.outputs.ref }}', checkout.fetch('with').fetch('ref')
  end

  def test_composite_action_declares_its_inputs
    action = YAML.load_file(File.join(ROOT, '.github/actions/setup-terraform/action.yml'))
    assert_equal 'composite', action.fetch('runs').fetch('using')
    %w[role_to_assume role_session_name].each do |name|
      assert_equal true, action.fetch('inputs').fetch(name).fetch('required')
    end
  end

  def test_shared_action_callers_supply_required_inputs
    callers = 0
    Dir.glob(File.join(ROOT, '.github/workflows/*.{yml,yaml}')).each do |path|
      document = YAML.load_file(path)
      document.fetch('jobs', {}).each do |job_name, job|
        job.fetch('steps', []).each do |step|
          next unless step['uses'] == './.github/actions/setup-terraform'
          %w[role_to_assume role_session_name].each do |input|
            assert step.fetch('with', {}).key?(input), "Missing #{input}: #{path}:#{job_name}"
          end
          callers += 1
        end
      end
    end
    assert_operator callers, :>, 0
  end

  def run_phase(phase, failing_stage: nil, failing_crd: false)
    Dir.mktmpdir('notify-helm-test') do |directory|
      helmfile_directory = File.join(directory, 'notification-manifests/helmfile')
      FileUtils.mkdir_p(helmfile_directory)
      File.write(File.join(helmfile_directory, 'getContext.sh'), "export TEST_CONTEXT_LOADED=yes\n")
      mock = <<~BASH
        helmfile() {
          [[ "$TEST_CONTEXT_LOADED" == yes ]] || return 90
          printf 'HELM %s\\n' "$*"
          [[ "$*" != *"step=#{failing_stage || 'none'} "* ]] || return 42
        }
        kubectl() { printf 'CRD %s\\n' "$*"; return #{failing_crd ? 43 : 0}; }
        export -f helmfile kubectl
        bash "$1" "$2"
      BASH
      Open3.capture3('bash', '-c', mock, 'test', SCRIPT, phase, chdir: directory)
    end
  end

  def test_bootstrap_stages_wait_before_crd_gate
    stdout, stderr, result = run_phase('bootstrap')
    assert result.success?, stderr
    assert_equal (0..4).map { |stage| "HELM -e dev -l step=#{stage} apply --wait" }, stdout.lines.grep(/^HELM/).map(&:strip)
    assert_includes stdout.lines.last, 'secretproviderclasses.secrets-store.csi.x-k8s.io'
    assert_includes stdout.lines.last, 'targetgroupbindings.elbv2.k8s.aws'
  end

  def test_bootstrap_failure_stops_later_stages
    (0..4).each do |stage|
      stdout, _stderr, result = run_phase('bootstrap', failing_stage: stage)
      assert_equal 42, result.exitstatus
      refute_includes stdout, "step=#{stage + 1} "
      refute_includes stdout, 'CRD '
    end
  end

  def test_missing_crd_fails_bootstrap
    _stdout, _stderr, result = run_phase('bootstrap', failing_crd: true)
    assert_equal 43, result.exitstatus
  end

  def test_application_waits_and_propagates_failure
    stdout, stderr, result = run_phase('application')
    assert result.success?, stderr
    assert_equal "HELM -e dev -l step=5 apply --wait\n", stdout
    _stdout, _stderr, failed = run_phase('application', failing_stage: 5)
    assert_equal 42, failed.exitstatus
  end

  def test_invalid_phase_is_rejected
    _stdout, _stderr, result = run_phase('invalid')
    assert_equal 2, result.exitstatus
  end
end