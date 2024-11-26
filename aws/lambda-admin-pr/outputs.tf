output "admin_pr_security_group_id" {
  value = aws_security_group.lambda_admin_pr_review[0].id
}
