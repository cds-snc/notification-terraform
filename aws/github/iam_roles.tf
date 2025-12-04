locals {
  notification_admin_test_admin_workflows   = "notification-admin-test-admin-workflows"
  notification_admin_cypress_e2e_tests      = "notification-admin-cypress-e2e-tests"
  notification_manifests_helmfile_diff      = "notification-manifests-helmfile-diff"
  notification_manifests_staging_smoke_test = "notification-manifests-staging-smoke-test"
  notification_manifests_k8s_lambda_apply   = "notification-manifests-k8s-lambda-apply"
  notification_api_build_push               = "notification-api-build-push"
  notification_admin_build_push             = "notification-admin-build-push"
  notification_document_download_build_push = "notification-document-download-build-push"
}

# 
# Built-in AWS policy attached to the roles
#
data "aws_iam_policy" "readonly" {
  name = "ReadOnlyAccess"
}

data "aws_iam_policy" "oidcplanpolicy" {
  name = "OIDCPlanPolicy"
}

#
# Create the OIDC roles used by the GitHub workflows
# The roles can be assumed by the GitHub workflows according to the `claim`
# attribute of each role.
# 
module "github_workflow_roles_admin" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  roles = [
    {
      name      = local.notification_admin_test_admin_workflows
      repo_name = "notification-admin"
      claim     = "pull_request"
    },
    {
      name      = local.notification_admin_cypress_e2e_tests
      repo_name = "notification-admin"
      claim     = "*"
    }
  ]
}

module "github_workflow_roles_manifests" {
  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  roles = [
    {
      name      = local.notification_manifests_helmfile_diff
      repo_name = "notification-manifests"
      claim     = "*"
    },
    {
      name      = local.notification_manifests_staging_smoke_test
      repo_name = "notification-manifests"
      claim     = "ref:refs/heads/*"
    },
    {
      name      = "${local.notification_manifests_k8s_lambda_apply}-main-branch"
      repo_name = "notification-manifests"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_notification_api" {
  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value

  roles = [
    {
      name      = "${local.notification_api_build_push}-dev-branch"
      repo_name = "notification-api"
      claim     = "ref:refs/heads/dev"
    },
    {
      name      = "${local.notification_api_build_push}-main-branch"
      repo_name = "notification-api"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_notification_admin" {
  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value

  roles = [
    {
      name      = "${local.notification_admin_build_push}-dev-branch"
      repo_name = "notification-admin"
      claim     = "ref:refs/heads/dev"
    },
    {
      name      = "${local.notification_admin_build_push}-main-branch"
      repo_name = "notification-admin"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_notification_document_download" {
  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value

  roles = [
    {
      name      = "${local.notification_document_download_build_push}-dev-branch"
      repo_name = "notification-document-download"
      claim     = "ref:refs/heads/dev"
    },
    {
      name      = "${local.notification_document_download_build_push}-main-branch"
      repo_name = "notification-document-download"
      claim     = "ref:refs/heads/main"
    }
  ]
}

#
# Attach polices to the OIDC roles to grant them permissions
#
resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_workflows" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_workflows
  policy_arn = aws_iam_policy.notification_admin_test_admin_workflows[0].arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_workflows_read_only" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_workflows
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_workflows_oidc_plan_policy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_workflows
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_cypress_e2e_tests" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_cypress_e2e_tests
  policy_arn = aws_iam_policy.notification_admin_cypress_e2e_tests[0].arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_cypress_e2e_tests_read_only" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_cypress_e2e_tests
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_cypress_e2e_tests_oidc_plan_policy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_cypress_e2e_tests
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_helmfile_diff" {
  role       = local.notification_manifests_helmfile_diff
  policy_arn = aws_iam_policy.notification_manifests_helmfile_diff.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_helmfile_diff_read_only" {
  role       = local.notification_manifests_helmfile_diff
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_helmfile_diff_oidc_plan_policy" {
  role       = local.notification_manifests_helmfile_diff
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_staging_smoke_test" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_manifests_staging_smoke_test
  policy_arn = aws_iam_policy.notification_manifests_staging_smoke_test[0].arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_staging_smoke_test_read_only" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_manifests_staging_smoke_test
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_staging_smoke_test_oidc_plan_policy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_manifests_staging_smoke_test
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_k8s_lambda_apply_main_branch" {
  role       = "${local.notification_manifests_k8s_lambda_apply}-main-branch"
  policy_arn = aws_iam_policy.notification_manifests_k8s_lambda_apply.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_k8s_lambda_apply_main_branch_read_only" {
  role       = "${local.notification_manifests_k8s_lambda_apply}-main-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_k8s_lambda_apply_main_branch_oidc_plan_policy" {
  role       = "${local.notification_manifests_k8s_lambda_apply}-main-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_manifests
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_dev_branch" {
  role       = "${local.notification_api_build_push}-dev-branch"
  policy_arn = aws_iam_policy.notification_api_build_push.arn
  depends_on = [
    module.github_workflow_roles_notification_api
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_dev_branch_read_only" {
  role       = "${local.notification_api_build_push}-dev-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_notification_api
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_dev_branch_oidc_plan_policy" {
  role       = "${local.notification_api_build_push}-dev-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_notification_api
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_main_branch" {
  role       = "${local.notification_api_build_push}-main-branch"
  policy_arn = aws_iam_policy.notification_api_build_push.arn
  depends_on = [
    module.github_workflow_roles_notification_api
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_main_branch_read_only" {
  role       = "${local.notification_api_build_push}-main-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_notification_api
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_main_branch_oidc_plan_policy" {
  role       = "${local.notification_api_build_push}-main-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_notification_api
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_build_push_dev_branch" {
  role       = "${local.notification_admin_build_push}-dev-branch"
  policy_arn = aws_iam_policy.notification_admin_build_push.arn
  depends_on = [
    module.github_workflow_roles_notification_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_build_push_dev_branch_read_only" {
  role       = "${local.notification_admin_build_push}-dev-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_notification_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_build_push_dev_branch_oidc_plan_policy" {
  role       = "${local.notification_admin_build_push}-dev-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_notification_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_build_push_main_branch" {
  role       = "${local.notification_admin_build_push}-main-branch"
  policy_arn = aws_iam_policy.notification_admin_build_push.arn
  depends_on = [
    module.github_workflow_roles_notification_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_build_push_main_branch_read_only" {
  role       = "${local.notification_admin_build_push}-main-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_notification_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_build_push_main_branch_oidc_plan_policy" {
  role       = "${local.notification_admin_build_push}-main-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_notification_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_document_download_build_push_dev_branch" {
  role       = "${local.notification_document_download_build_push}-dev-branch"
  policy_arn = aws_iam_policy.notification_document_download_build_push.arn
  depends_on = [
    module.github_workflow_roles_notification_document_download
  ]
}

resource "aws_iam_role_policy_attachment" "notification_document_download_build_push_dev_branch_read_only" {
  role       = "${local.notification_document_download_build_push}-dev-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_notification_document_download
  ]
}

resource "aws_iam_role_policy_attachment" "notification_document_download_build_push_dev_branch_oidc_plan_policy" {
  role       = "${local.notification_document_download_build_push}-dev-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_notification_document_download
  ]
}

resource "aws_iam_role_policy_attachment" "notification_document_download_build_push_main_branch" {
  role       = "${local.notification_document_download_build_push}-main-branch"
  policy_arn = aws_iam_policy.notification_document_download_build_push.arn
  depends_on = [
    module.github_workflow_roles_notification_document_download
  ]
}

resource "aws_iam_role_policy_attachment" "notification_document_download_build_push_main_branch_read_only" {
  role       = "${local.notification_document_download_build_push}-main-branch"
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_notification_document_download
  ]
}

resource "aws_iam_role_policy_attachment" "notification_document_download_build_push_main_branch_oidc_plan_policy" {
  role       = "${local.notification_document_download_build_push}-main-branch"
  policy_arn = data.aws_iam_policy.oidcplanpolicy.arn
  depends_on = [
    module.github_workflow_roles_notification_document_download
  ]
}
