output "admin_pr_security_group_id" {
  value = var.env == "staging" ? aws_security_group.lambda_admin_pr_review[0].id : ""
}
