resource "aws_securityhub_standards_subscription" "cis" {
  provider      = aws.core_services
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}
