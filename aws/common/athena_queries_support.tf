resource "aws_athena_named_query" "find_blocked_ips" {
  name        = "WAF: find blocked ips"
  description = "TF: find ips that Notify has recently blocked"
  workgroup   = aws_athena_workgroup.primary.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/find_blocked_ips.sql.tmpl", {})
}
