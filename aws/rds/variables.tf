variable "eks_cluster_securitygroup" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "rds_cluster_password" {
  type      = string
  sensitive = true
}

variable "app_db_user_password" {
  type      = string
  sensitive = true
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

variable "enable_delete_protection" {
  type        = bool
  description = "Sets whether or not to enable delete protection."
  default     = true
}

variable "rds_database_name" {
  type        = string
  description = "Set the name of the database"
}

variable "sentinel_forwarder_cloudwatch_lambda_name" {
  type        = string
  description = "Name of the Sentinel forwarder lambda function."
}

variable "sentinel_forwarder_cloudwatch_lambda_arn" {
  type        = string
  description = "ARN of the Sentinel forwarder lambda function."
}

variable "enable_sentinel_forwarding" {
  type        = bool
  description = "Enable forwarding of logs to Sentinel."
  default     = false

}

variable "rds_version" {
  type        = string
  description = "The version of the RDS instance."
  default     = "15.5"
}

variable "recovery" {
  type        = bool
  description = "Set to true if you want to recover from a snapshot."
  default     = false
}

variable "rds_snapshot_identifier" {
  type        = string
  description = "The snapshot identifier to recover from."
  default     = "" 
} 