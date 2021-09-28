variable "admin_client_secret" {
  type      = string
  sensitive = true
}

variable "admin_client_user_name" {
  type      = string
  sensitive = true
}

variable "api_host_name" {
  type = string
}

variable "asset_domain" {
  type = string
}

variable "asset_upload_bucket_name" {
  type = string
}

variable "auth_tokens" {
  type      = string
  sensitive = true
}

// check if this already exists
variable "aws_pinpoint_region" {
  type = string
}

// check if this already exists
variable "base_domain" {
  type = string
}

variable "csv_upload_bucket_name" {
  type = string
}

variable "dangerous_salt" {
  type      = string
  sensitive = true
}

variable "documents_bucket" {
  type = string
}

variable "mlwr_host" {
  type = string
}

variable "notification_queue_prefix" {
  type = string
}

variable "redis_enabled" {
  type = string
}

variable "redis_url" {
  type = string
}

variable "secret_key" {
  type      = string
  sensitive = true
}

variable "sqlalchemy_database_reader_uri" {
  type = string
}

variable "sqlalchemy_database_uri" {
  type = string
}

variable "sqlalchemy_pool_size" {
  type = string
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "eks_cluster_securitygroup" {
  type = string
}

variable "document_download_api_host" {
  type = string
}

variable "api_image_tag" {
  type = string
}

variable "scaling_min_capacity" {
  type = number
}

variable "scaling_max_capacity" {
  type = number
}

variable "scaling_target_value" {
  type = number
}
