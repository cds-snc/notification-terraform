variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "google_cidr_schedule_expression" {
  type        = string
  description = "This aws cloudwatch event rule scheule expression that specifies when the scheduler runs."
}

variable "google_cidr_prefix_list_id" {
  type        = string
  description = "The prefix list id for the Google service CIDR ranges"
}
