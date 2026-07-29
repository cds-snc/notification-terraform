resource "aws_athena_named_query" "waf_rule_hit_counts" {
  name        = "WAF: rule hit counts"
  description = "Counts of requests matched per WAF rule (last 7 days), split by BLOCK and COUNT mode. Use to baseline count-mode rules before switching to block."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_rule_hit_counts.sql.tmpl", {})
}

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

resource "aws_athena_named_query" "alb_ip_address_by_url" {
  name        = "ALB: Lookup IP By URL"
  description = "Find ips based on the URL hit between a date range"
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/alb_ip_lookup_by_url.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_ssrf_body_hits" {
  name        = "WAF: EC2 metadata SSRF body hits"
  description = "Managed EC2MetaDataSSRF_BODY hits (excluding api.*, which is not covered by the downstream label rule)."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_ssrf_body_hits.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_ssrf_body_alb_correlation" {
  name        = "WAF: EC2 metadata SSRF body + ALB correlation"
  description = "EC2MetaDataSSRF_BODY hits joined with ALB access logs on client IP + timestamp (±5s) so you can see the full URL, user-agent, and response codes."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_ssrf_body_alb_correlation.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_xss_body_hits" {
  name        = "WAF: XSS body hits"
  description = "Managed CrossSiteScripting_BODY hits (excluding api.document.*, where XLSX/DOCX uploads inherently trip the rule and are already excluded by the downstream label rule)."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_xss_body_hits.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_sqli_body_custom_hits" {
  name        = "WAF: SQLi body hits (custom rule)"
  description = "Hits on the custom count-mode rule BlockSQLi_Body_ExcludeContentPaths."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_sqli_body_custom_hits.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_sqli_body_managed_hits" {
  name        = "WAF: SQLi body hits (managed rules)"
  description = "Managed SQLi_BODY / SQLi_BODY_RC_COUNT / SQLiExtendedPatterns_Body_RC_COUNT hits (excluding api.*, which is not covered by the downstream label rule)."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_sqli_body_managed_hits.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_hosting_provider_hits" {
  name        = "WAF: HostingProviderIPList hits"
  description = "Managed HostingProviderIPList hits (AWSManagedRulesAnonymousIpList)."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_hosting_provider_hits.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_admin_geo_restriction_hits" {
  name        = "WAF: admin geo restriction hits"
  description = "Hits on the custom AdminAuthenticatedPagesGeoRestriction rule (non-CA/US traffic on admin-authenticated paths)."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_admin_geo_restriction_hits.sql.tmpl", {})
}

resource "aws_athena_named_query" "waf_size_restrictions_body_hits" {
  name        = "WAF: SizeRestrictions body hits"
  description = "Managed SizeRestrictions_BODY hits (~8 KB threshold), excluding api.* which is guarded by the 7 MB BlockLargeRequests_Body_Api rule."
  workgroup   = aws_athena_workgroup.support.name
  database    = aws_athena_database.notification_athena.name
  query       = templatefile("${path.module}/sql/waf_size_restrictions_body_hits.sql.tmpl", {})
}
