variable "perf_test_phone_number" {
  sensitive   = true
  type        = string
  description = "Identifies delivery phone number."
}
variable "perf_test_email" {
  sensitive   = true
  type        = string
  description = "Identifies delivery email address."
}
variable "perf_test_domain" {
  sensitive   = true
  type        = string
  description = "Identifies performance test domain."
}
variable "perf_test_auth_header" {
  sensitive   = true
  type        = string
  description = "Identifies api auth header."
}

variable "billing_tag_key" {
  type = string
}
variable "billing_tag_value" {
  type = string
}
variable "name" {
  type    = string
  default = "perf-test"
}
variable "vpc_id" {
  type = string
}
variable "vpc_public_subnets" {
  type = list(string)
}
variable "perf_test_aws_s3_bucket" {
  type        = string
  description = "Identifies aws s3 bucket."
}
variable "perf_test_csv_directory_path" {
  type        = string
  description = "Identifies the csv directory."
}
variable "perf_test_sms_template_id" {
  type        = string
  description = "Identifies sms template id."
}
variable "perf_test_bulk_email_template_id" {
  type        = string
  description = "Identifies bulk email template id."
}
variable "perf_test_email_template_id" {
  type        = string
  description = "Identifies email template id."
}
variable "perf_test_email_with_attachment_template_id" {
  type        = string
  description = "Identifies email with attachment template id."
}
variable "perf_test_email_with_link_template_id" {
  type        = string
  description = "Identifies email with link template id."
}

variable "private-links-vpc-endpoints-securitygroup" {
  type        = string
  description = "Security group for vpc endpoints to enable private link"
}

variable "private-links-gateway-prefix-list-ids" {
  type        = list(any)
  description = "private links gateway"
}
variable "performance_test_ecr_repository_url" {
  type        = string
  description = "The ECR repo URL for performance test for the ecr dependency"
}