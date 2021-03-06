variable "eks_cluster_securitygroup" {
  type = string
}

variable "rds_cluster_password" {
  type = string
}

variable "rds_instance_count" {
  type    = number
  default = 1
}

variable "rds_instance_type" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "sns_alert_general_arn" {
  type = string
}
