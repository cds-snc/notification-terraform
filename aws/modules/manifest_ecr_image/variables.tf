variable "environment" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "tag_key" {
  type = string
}

variable "manifest_ref" {
  type    = string
  default = "main"
}
