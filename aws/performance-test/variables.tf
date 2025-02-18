variable "vpc_id" {
  type = string
}
variable "vpc_public_subnets" {
  type = list(string)
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

variable "database_read_only_proxy_endpoint" {
  type = string
}
