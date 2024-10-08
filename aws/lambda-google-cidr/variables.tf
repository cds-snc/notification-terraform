variable "google_cidr_prefix_list_id" {
  type        = string
  description = "The prefix list id for the Google service CIDR ranges"
}

variable "google_cidr_ecr_repository_url" {
  type        = string
  description = "Inherited from ecr dependency"
}

variable "google_cidr_ecr_arn" {
  type        = string
  description = "Inherited from ecr dependency"
}