locals {
  notification_admin_test_admin_deploy      = "notification-admin-test-admin-deploy"
  notification_manifests_helmfile_diff      = "notification-manifests-helmfile-diff"
  notification_manifests_staging_smoke_test = "notification-manifests-staging-smoke-test"
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
      name      = local.notification_admin_test_admin_deploy
      repo_name = "notification-admin"
      claim     = "ref:refs/heads/*"
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
      claim     = "ref:refs/heads/*"
    },
    {
      name      = local.notification_manifests_staging_smoke_test
      repo_name = "notification-manifests"
      claim     = "ref:refs/heads/*"
    }
  ]
}

#
# Attach polices to the OIDC roles to grant them permissions
#
resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_deploy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_deploy
  policy_arn = aws_iam_policy.notification_admin_test_admin_deploy[0].arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_deploy_read_only" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_deploy
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles_admin
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_deploy_oidc_plan_policy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_deploy
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
