variable "eks_cluster_securitygroup" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_general_arn" {
  type = string
}

variable "sentinel_forwarder_cloudwatch_lambda_name" {
  type        = string
  description = "Name of the Sentinel forwarder lambda function."
}

variable "sentinel_forwarder_cloudwatch_lambda_arn" {
  type        = string
  description = "ARN of the Sentinel forwarder lambda function."
}
