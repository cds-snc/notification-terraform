variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

variable "billing_tag_value" {
  type        = string
  description = "Identifies the billing code."
}

variable "billing_tag_key" {
  type = string
}

variable "DATABASE_URL" {
  type      = string
  sensitive = true
}
