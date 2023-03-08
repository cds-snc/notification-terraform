variable "redis_cluster_security_group_id" {
  description = "Security group ID for the Redis cluster."
  type        = string
}

variable "vpc_endpoint_gateway_prefix_list_ids" {
  description = "Prefix list IDs of the VPC private gateway endpoints."
  type        = list(string)
}

variable "vpc_endpoint_security_group_id" {
  description = "Security group ID used by the VPC private interface endpoints."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to create the lambda's security group in."
  type        = string
}
