terraform {
  source = "../../../aws//performance-test"
}

dependencies {
  paths = ["../common", "../eks", "../ecr"]
}

dependency "common" {
  config_path = "../common"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    vpc_id = ""
    vpc_public_subnets = [
      "",
      "",
      "",
    ]
    private-links-vpc-endpoints-securitygroup = ""
    private-links-gateway-prefix-list-ids = []
  }
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["init", "fmt", "validate", "plan", "show"]
  mock_outputs = {
    eks-cluster-securitygroup = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_securitygroup = dependency.eks.outputs.eks-cluster-securitygroup
  vpc_public_subnets        = dependency.common.outputs.vpc_public_subnets
  vpc_id                    = dependency.common.outputs.vpc_id
  aws_pinpoint_region       = "ca-central-1"

  billing_tag_key                             = "CostCenter"
  billing_tag_value                           = "notification-canada-ca-sandbox"
  schedule_expression                         = "cron(0 0 * * ? *)"
  perf_test_aws_s3_bucket                     = "notify-performance-test-results-sandbox"
  perf_test_csv_directory_path                = "/tmp/notify_performance_test"
  perf_test_sms_template_id                   = "d5fea9f3-f69d-481e-9186-b7f4eaa5cf63"
  perf_test_bulk_email_template_id            = "fa759679-30f2-4666-94e2-bd4921329c46"
  perf_test_email_template_id                 = "fa759679-30f2-4666-94e2-bd4921329c46"
  perf_test_email_with_attachment_template_id = "fa759679-30f2-4666-94e2-bd4921329c46"
  perf_test_email_with_link_template_id       = "9fb324a5-821d-4b54-9d52-d9ba1fa8373a"
  private-links-vpc-endpoints-securitygroup   = dependency.common.outputs.private-links-vpc-endpoints-securitygroup
  private-links-gateway-prefix-list-ids       = dependency.common.outputs.private-links-gateway-prefix-list-ids
  performance_test_ecr_repository_url         = dependency.ecr.outputs.performance_test_ecr_repository_url
}


