resource "aws_athena_named_query" "find_blocked_ips" {
  name        = "WAF: find blocked ips"
  description = "Find ips that Notify has recently blocked"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/find_blocked_ips.sql.tmpl", {})
}


resource "aws_athena_named_query" "requests_by_date_country" {
  name        = "WAF: requests by date and country"
  description = "Counts of requests by date and country"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/request_by_date_country.sql.tmpl", {})
}


resource "aws_athena_named_query" "investigate_ip" {
  name        = "WAF: investigate ip"
  description = "Look at the WAF logs for one particular ip"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/investigate_ip.sql.tmpl", {})
}

resource "aws_athena_named_query" "http_five_hundreds" {
  name        = "ALB: find 500 errors"
  description = "Find 500 errors in the ALB logs"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/find_500s.sql.tmpl", {})
}

resource "aws_athena_named_query" "http_four_hundreds" {
  name        = "ALB: find 400 errors"
  description = "Find 400 errors in the ALB logs"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/find_400s.sql.tmpl", {})
}

resource "aws_athena_named_query" "direct_ip_queries" {
  name        = "WAF: Direct IPs hits by hosts, countries, actions and URIs"
  description = "Find requests made directly to ips rather than urls"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/direct_ip_queries.sql.tmpl", {})
}

resource "aws_athena_named_query" "monitor_blocked_requests" {
  name        = "WAF: monitor blocked requests"
  description = "See what requests have been blocked"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/monitor_blocked_requests.sql.tmpl", {})
}

resource "aws_athena_named_query" "fuzzing_attack" {
  name        = "WAF: Fuzzing attack (not blocked)"
  description = "Find ips with a lot of requests allowed through the WAF"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/fuzzing_attack.sql.tmpl", {})
}
