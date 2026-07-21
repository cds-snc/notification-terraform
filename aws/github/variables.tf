variable "shared_staging_kms_key_id" {
  type      = string
  sensitive = true
}

variable "gha_vpn_id" {
  type    = string
  default = ""
}

variable "gha_vpn_certificate" {
  type      = string
  sensitive = true
  default   = ""
}

variable "gha_vpn_key" {
  type      = string
  sensitive = true

  validation {
    condition     = trimspace(var.gha_vpn_key) != ""
    error_message = "gha_vpn_key must be a non-empty PEM string."
  }
}