variable "vpc_ids" {
  type        = list(string)
  description = "List of VPC IDs to enable Route53 resolver query logging"
  default     = []
}
