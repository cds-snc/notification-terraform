locals {
  notification_admin_test_admin_workflows               = "notification-admin-test-admin-workflows"
  notification_admin_cypress_e2e_tests                  = "notification-admin-cypress-e2e-tests"
  notification_manifests_helmfile_diff                  = "notification-manifests-helmfile-diff"
  notification_manifests_staging_smoke_test             = "notification-manifests-staging-smoke-test"
  notification_manifests_k8s_lambda_apply               = "notification-manifests-k8s-lambda-apply"
  notification_lambdas_apply                            = "notification-lambdas-apply"
  notification_api_build_push                           = "notification-api-build-push"
  notification_admin_build_push                         = "notification-admin-build-push"
  notification_document_download_build_push             = "notification-document-download-build-push"
  dkim_audit                                            = "dkim-audit"
  notification_performance_test_results                 = "notification-performance-test-results-sync"
  notification_terraform_check_eks_ami_update           = "notification-terraform-check-eks-ami-update"
  notification_terraform_check_eks_cluster_update       = "notification-terraform-check-eks-cluster-update"
  notification_terraform_sanitize_production_sms        = "notification-terraform-sanitize-production-sms-usage"
  notification_terraform_sanitize_staging_sms           = "notification-terraform-sanitize-staging-sms-usage"
  notification_manifests_helmfile_staging_apply         = "notification-manifests-helmfile-staging-apply"
  notification_manifests_helmfile_production_apply      = "notification-manifests-helmfile-production-apply"
  notification_manifests_database_migration_staging     = "notification-manifests-database-migration-staging"
  notification_manifests_database_migration_production  = "notification-manifests-database-migration-production"
  notification_manifests_smoke_test_production          = "notification-manifests-smoke-test-production"
  notification_admin_test_delete_unused                 = "notification-admin-test-delete-unused"
  notification_api_build_push_performance_test          = "notification-api-build-push-performance-test"
  notification_api_lambda_production                    = "notification-api-lambda-production"
  notification_api_lambda_staging                       = "notification-api-lambda-staging"
  notification_system_status_frontend_upload_to_s3      = "notification-system-status-frontend-upload-to-s3"
  notification_system_status_frontend_prod_upload_to_s3 = "notification-system-status-frontend-prod-upload-to-s3"
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

data "aws_iam_role" "notification_lambdas_apply" {
  name = local.notification_lambdas_apply
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
      repo_name = "notification-document-download-api"
      claim     = "ref:refs/heads/dev"
    },
    {
      name      = "${local.notification_document_download_build_push}-main-branch"
      repo_name = "notification-document-download-api"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_dkim_audit" {
  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = "${local.dkim_audit}-main"
      repo_name = "notification-terraform"
      claim     = "ref:refs/heads/main"
    },
    {
      name      = "${local.dkim_audit}-dkim-fix"
      repo_name = "notification-terraform"
      claim     = "ref:refs/heads/dkim-fix"
    }
  ]
}

module "github_workflow_roles_performance_test_results" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value

  roles = [
    {
      name      = local.notification_performance_test_results
      repo_name = "notification-performance-test-results"
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

resource "aws_iam_role_policy_attachment" "notification_lambdas_apply" {
  role       = data.aws_iam_role.notification_lambdas_apply.name
  policy_arn = aws_iam_policy.notification_lambdas_apply.arn
}

#
# notification-terraform workflow roles
#
module "github_workflow_roles_notification_terraform_staging" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_terraform_check_eks_ami_update
      repo_name = "notification-terraform"
      claim     = "ref:refs/heads/main"
    },
    {
      name      = local.notification_terraform_check_eks_cluster_update
      repo_name = "notification-terraform"
      claim     = "ref:refs/heads/main"
    },
    {
      name      = local.notification_terraform_sanitize_staging_sms
      repo_name = "notification-terraform"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_notification_terraform_production" {
  count = var.env == "production" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_terraform_sanitize_production_sms
      repo_name = "notification-terraform"
      claim     = "ref:refs/heads/main"
    }
  ]
}

resource "aws_iam_role_policy_attachment" "notification_terraform_check_eks_ami_update" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_terraform_check_eks_ami_update
  policy_arn = aws_iam_policy.notification_terraform_check_eks_ami_update[0].arn
  depends_on = [module.github_workflow_roles_notification_terraform_staging]
}

resource "aws_iam_role_policy_attachment" "notification_terraform_check_eks_cluster_update" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_terraform_check_eks_cluster_update
  policy_arn = aws_iam_policy.notification_terraform_check_eks_cluster_update[0].arn
  depends_on = [module.github_workflow_roles_notification_terraform_staging]
}

resource "aws_iam_role_policy_attachment" "notification_terraform_sanitize_staging_sms" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_terraform_sanitize_staging_sms
  policy_arn = aws_iam_policy.notification_terraform_sanitize_staging_sms[0].arn
  depends_on = [module.github_workflow_roles_notification_terraform_staging]
}

resource "aws_iam_role_policy_attachment" "notification_terraform_sanitize_production_sms" {
  count = var.env == "production" ? 1 : 0

  role       = local.notification_terraform_sanitize_production_sms
  policy_arn = aws_iam_policy.notification_terraform_sanitize_production_sms[0].arn
  depends_on = [module.github_workflow_roles_notification_terraform_production]
}

#
# DKIM Audit role
#
resource "aws_iam_role_policy_attachment" "dkim_audit_main" {
  role       = "${local.dkim_audit}-main"
  policy_arn = aws_iam_policy.dkim_audit.arn
  depends_on = [
    module.github_workflow_roles_dkim_audit
  ]
}

resource "aws_iam_role_policy_attachment" "dkim_audit_dkim_fix" {
  role       = "${local.dkim_audit}-dkim-fix"
  policy_arn = aws_iam_policy.dkim_audit.arn
  depends_on = [
    module.github_workflow_roles_dkim_audit
  ]
}

#
# Performance Test Results Sync role
#
resource "aws_iam_role_policy_attachment" "notification_performance_test_results" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_performance_test_results
  policy_arn = aws_iam_policy.notification_performance_test_results[0].arn
  depends_on = [
    module.github_workflow_roles_performance_test_results
  ]
}

#
# notification-manifests workflow roles
#
module "github_workflow_roles_notification_manifests_staging" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_manifests_helmfile_staging_apply
      repo_name = "notification-manifests"
      claim     = "ref:refs/heads/main"
    },
    {
      name      = local.notification_manifests_database_migration_staging
      repo_name = "notification-manifests"
      claim     = "*"
    }
  ]
}

module "github_workflow_roles_notification_manifests_production" {
  count = var.env == "production" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_manifests_helmfile_production_apply
      repo_name = "notification-manifests"
      claim     = "ref:refs/heads/main"
    },
    {
      name      = local.notification_manifests_database_migration_production
      repo_name = "notification-manifests"
      claim     = "*"
    },
    {
      name      = local.notification_manifests_smoke_test_production
      repo_name = "notification-manifests"
      claim     = "*"
    }
  ]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_helmfile_staging_apply" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_manifests_helmfile_staging_apply
  policy_arn = aws_iam_policy.notification_manifests_helmfile_apply[0].arn
  depends_on = [module.github_workflow_roles_notification_manifests_staging]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_database_migration_staging" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_manifests_database_migration_staging
  policy_arn = aws_iam_policy.notification_manifests_database_migration[0].arn
  depends_on = [module.github_workflow_roles_notification_manifests_staging]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_helmfile_production_apply" {
  count = var.env == "production" ? 1 : 0

  role       = local.notification_manifests_helmfile_production_apply
  policy_arn = aws_iam_policy.notification_manifests_helmfile_apply_production[0].arn
  depends_on = [module.github_workflow_roles_notification_manifests_production]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_database_migration_production" {
  count = var.env == "production" ? 1 : 0

  role       = local.notification_manifests_database_migration_production
  policy_arn = aws_iam_policy.notification_manifests_database_migration_production[0].arn
  depends_on = [module.github_workflow_roles_notification_manifests_production]
}

resource "aws_iam_role_policy_attachment" "notification_manifests_smoke_test_production" {
  count = var.env == "production" ? 1 : 0

  role       = local.notification_manifests_smoke_test_production
  policy_arn = aws_iam_policy.notification_manifests_smoke_test_production[0].arn
  depends_on = [module.github_workflow_roles_notification_manifests_production]
}

#
# notification-admin workflow roles
#
module "github_workflow_roles_notification_admin_staging_ops" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_admin_test_delete_unused
      repo_name = "notification-admin"
      claim     = "*"
    }
  ]
}

resource "aws_iam_role_policy_attachment" "notification_admin_test_delete_unused" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_admin_test_delete_unused
  policy_arn = aws_iam_policy.notification_admin_test_delete_unused[0].arn
  depends_on = [module.github_workflow_roles_notification_admin_staging_ops]
}

#
# notification-api workflow roles
#
module "github_workflow_roles_notification_api_ops_staging" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_api_build_push_performance_test
      repo_name = "notification-api"
      claim     = "ref:refs/heads/main"
    },
    {
      name      = local.notification_api_lambda_staging
      repo_name = "notification-api"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_notification_api_ops_production" {
  count = var.env == "production" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_api_lambda_production
      repo_name = "notification-api"
      claim     = "ref:refs/heads/main"
    }
  ]
}

resource "aws_iam_role_policy_attachment" "notification_api_build_push_performance_test" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_api_build_push_performance_test
  policy_arn = aws_iam_policy.notification_api_build_push_performance_test[0].arn
  depends_on = [module.github_workflow_roles_notification_api_ops_staging]
}

resource "aws_iam_role_policy_attachment" "notification_api_lambda_staging" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_api_lambda_staging
  policy_arn = aws_iam_policy.notification_api_lambda_staging[0].arn
  depends_on = [module.github_workflow_roles_notification_api_ops_staging]
}

resource "aws_iam_role_policy_attachment" "notification_api_lambda_production" {
  count = var.env == "production" ? 1 : 0

  role       = local.notification_api_lambda_production
  policy_arn = aws_iam_policy.notification_api_lambda_production[0].arn
  depends_on = [module.github_workflow_roles_notification_api_ops_production]
}

#
# notification-system-status-frontend workflow roles
#
module "github_workflow_roles_notification_system_status_staging" {
  count = var.env == "staging" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_system_status_frontend_upload_to_s3
      repo_name = "notification-system-status-frontend"
      claim     = "ref:refs/heads/main"
    }
  ]
}

module "github_workflow_roles_notification_system_status_production" {
  count = var.env == "production" ? 1 : 0

  source            = "github.com/cds-snc/terraform-modules//gh_oidc_role?ref=64b19ecfc23025718cd687e24b7115777fd09666" # v10.2.1
  billing_tag_value = var.billing_tag_value
  org_name          = "cds-snc"

  roles = [
    {
      name      = local.notification_system_status_frontend_prod_upload_to_s3
      repo_name = "notification-system-status-frontend"
      claim     = "ref:refs/tags/*"
    }
  ]
}

resource "aws_iam_role_policy_attachment" "notification_system_status_frontend_upload_to_s3" {
  count = var.env == "staging" ? 1 : 0

  role       = local.notification_system_status_frontend_upload_to_s3
  policy_arn = aws_iam_policy.notification_system_status_frontend_upload_to_s3[0].arn
  depends_on = [module.github_workflow_roles_notification_system_status_staging]
}

resource "aws_iam_role_policy_attachment" "notification_system_status_frontend_prod_upload_to_s3" {
  count = var.env == "production" ? 1 : 0

  role       = local.notification_system_status_frontend_prod_upload_to_s3
  policy_arn = aws_iam_policy.notification_system_status_frontend_prod_upload_to_s3[0].arn
  depends_on = [module.github_workflow_roles_notification_system_status_production]
}
