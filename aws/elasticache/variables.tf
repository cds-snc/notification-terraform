variable "eks_cluster_securitygroup" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_warning_arn" {
  type = string
}

variable "sns_alert_critical_arn" {
  type = string
}

variable "kms_arn" {
  type = string
}