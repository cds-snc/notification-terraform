variable "schedule_expression" {
  default     = "cron(0 0 * * ? *)"
  description = "This aws cloudwatch event rule scheule expression that specifies when the scheduler runs."
}
variable "env" {
  default     = "staging"
  description = "This helps identify the environment within which would run."
}
variable "aws_access_key_id" {
  default     = ""
  description = "This helps identify aws access key."
}
variable "aws_secret_access_key" {
  default     = ""
  description = "This helps identify aws access key."
}
variable "aws_default_output" {
  default     = "json"
  description = "This helps identify aws access key."
}
variable "aws_default_region" {
  default     = "ca-central-1"
  description = "This helps identify aws access key."
}
variable "load_test_phone_number" {
  default     = "16132532222"
  description = "This helps identify aws access key."
}
variable "load_test_email" {
  default     = "success@simulator.amazonses.com"
  description = "This helps identify aws access key."
}
variable "load_test_aws_s3_bucket" {
  default     = "notify-performance-test-results-${var.env}"
  description = "This helps identify aws s3 bucket."
}
variable "load_test_csv_directory_path" {
  default     = "/tmp/notify_performance_test"
  description = "This helps identify aws access key."
}
variable "load_test_domain" {
  default     = "https://api.staging.notification.cdssandbox.xyz"
  description = "This helps identify performance test domain."
}
variable "load_test_sms_template_id" {
  default     = "83d01f06-a818-4134-bd69-ce90a2949280"
  description = "This helps identify performance test domain."
}
variable "load_test_bulk_email_template_id" {
  default     = "5ebee3b7-63c0-4052-a8cb-387b818df627"
  description = "This helps identify performance test domain."
}
variable "load_test_email_template_id" {
  default     = "a59b313d-8de2-4973-ac2f-66de7ec0b239"
  description = "This helps identify performance test domain."
}
variable "load_test_email_with_attachment_template_id" {
  default     = "a59b313d-8de2-4973-ac2f-66de7ec0b239"
  description = "This helps identify performance test domain."
}
variable "load_test_email_with_link_template_id" {
  default     = "5ebee3b7-63c0-4052-a8cb-387b818df627"
  description = "This helps identify performance test domain."
}
variable "test_auth_header" {
  default     = "apikey-v1 c55039fc-c0e1-44db-a14e-b6a669148ec6"
  description = "This helps identify performance test domain."
}
