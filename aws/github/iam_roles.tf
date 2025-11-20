locals {
  notification_admin_test_admin_deploy = "notification-admin-test-admin-deploy"
  notification_oidc_plan_policy        = "OIDCPlanPolicy"
}

# 
# Built-in AWS policy attached to the roles
#
data "aws_iam_policy" "readonly" {
  name = "ReadOnlyAccess"
}

#
# Create the OIDC roles used by the GitHub workflows
# The roles can be assumed by the GitHub workflows according to the `claim`
# attribute of each role.
# 
module "github_workflow_roles" {
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

#
# Attach polices to the OIDC roles to grant them permissions
#
resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_deploy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_deploy
  policy_arn = aws_iam_policy.notification_admin_test_admin_deploy[0].arn
  depends_on = [
    module.github_workflow_roles
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_deploy_read_only" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_deploy
  policy_arn = data.aws_iam_policy.readonly.arn
  depends_on = [
    module.github_workflow_roles
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_admin_deploy_oidc_plan_policy" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_admin_deploy
  policy_arn = aws_iam_policy.notification_oidc_plan_policy.arn
  depends_on = [
    module.github_workflow_roles
  ]
}
