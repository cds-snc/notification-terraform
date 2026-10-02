variable "environment" {
  type = string
}

variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "tag_key" {
  type = string
}

variable "manifest_ref" {
  type    = string
  default = "main"
}

variable "verify_ecr_image" {
  type    = bool
  default = true
}