variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the subnets"
}

variable "eks_securitygroup_rds" {
  type        = string
  description = "The security group for the RDS"
}

variable "eks_cluster_securitygroup_id" {
  type        = string
  description = "The security group for the EKS cluster"
}

variable "eks_application_log_group" {
  type        = string
  description = "The log group for the EKS application"
}