variable "heartbeat_api_key" {
  sensitive   = true
  type        = string
  description = "Identifies delivery phone number."
}

variable "heartbeat_base_url" {
  sensitive   = true
  type        = list(string)
  description = "Identifies delivery phone number."
}

variable "heartbeat_template_id" {
  sensitive   = true
  type        = string
  description = "Identifies delivery phone number."
}

variable "schedule_expression" {
  type        = string
  description = "This aws cloudwatch event rule scheule expression that specifies when the scheduler runs."
}