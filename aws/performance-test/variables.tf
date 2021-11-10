variable "schedule_expression" {
  type        = string
  default     = "cron(0 0 * * ? *)"
  description = "This aws cloudwatch event rule scheule expression that specifies when the scheduler runs."
}
variable "perf_test_phone_number" {
  type        = string
  default     = "16132532222"
  description = "Identifies delivery phone number."
}
variable "perf_test_email" {
  type        = string
  default     = "success@simulator.amazonses.com"
  description = "Identifies delivery email address."
}
variable "perf_test_aws_s3_bucket" {
  type        = string
  default     = "notify-performance-test-results-staging"
  description = "Identifies aws s3 bucket."
}
variable "perf_test_csv_directory_path" {
  type        = string
  default     = "/tmp/notify_performance_test"
  description = "Identifies the csv directory."
}
variable "perf_test_domain" {
  type        = string
  default     = "https://api.staging.notification.cdssandbox.xyz"
  description = "Identifies performance test domain."
}
variable "perf_test_sms_template_id" {
  type        = string
  default     = "83d01f06-a818-4134-bd69-ce90a2949280"
  description = "Identifies sms template id."
}
variable "perf_test_bulk_email_template_id" {
  type        = string
  default     = "5ebee3b7-63c0-4052-a8cb-387b818df627"
  description = "Identifies bulk email template id."
}
variable "perf_test_email_template_id" {
  type        = string
  default     = "a59b313d-8de2-4973-ac2f-66de7ec0b239"
  description = "Identifies email template id."
}
variable "perf_test_email_with_attachment_template_id" {
  type        = string
  default     = "a59b313d-8de2-4973-ac2f-66de7ec0b239"
  description = "Identifies email with attachment template id."
}
variable "perf_test_email_with_link_template_id" {
  type        = string
  default     = "5ebee3b7-63c0-4052-a8cb-387b818df627"
  description = "Identifies email with link template id."
}
variable "test_auth_header" {
  type        = string
  default     = "apikey-v1 c55039fc-c0e1-44db-a14e-b6a669148ec6"
  description = "Identifies api auth header."
}
