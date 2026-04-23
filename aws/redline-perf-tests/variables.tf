###
# Networking
###
variable "locust_vpc_cidr_block" {
  type        = string
  description = "CIDR block for the isolated Locust VPC"
  default     = "10.10.0.0/16"
}

###
# Container image
###
variable "locust_image" {
  type        = string
  description = "Optional full Docker image URI override for the Locust container. Leave unset to use this module's ECR repository."
  default     = null
}

variable "locust_image_tag" {
  type        = string
  description = "Optional image tag to deploy from this module's ECR repository when locust_image is not set. Leave unset to use bootstrap during bootstrap runs, otherwise latest."
  default     = null
}

variable "locust_file_path" {
  type        = string
  description = "Path to the locustfile inside the container image"
  default     = "/mnt/locust/locust_throughput.py"
}

variable "locust_config_path" {
  type        = string
  description = "Path to the locust.conf file inside the container image"
  default     = "/mnt/locust/locust.conf"
}

###
# Load test parameters
###
variable "locust_target_host" {
  type        = string
  description = "Target host URL that Locust will load test"
  default     = "https://api.staging.notification.cdssandbox.xyz"
}

variable "locust_worker_count" {
  type        = number
  description = "Number of Locust worker containers to run"
  default     = 2
}

###
# Task sizing
###
variable "master_cpu" {
  type        = number
  description = "CPU units for the Locust master task (1024 = 1 vCPU)"
  default     = 1024
}

variable "master_memory" {
  type        = number
  description = "Memory (MiB) for the Locust master task"
  default     = 2048
}

variable "worker_cpu" {
  type        = number
  description = "CPU units for each Locust worker task"
  default     = 1024
}

variable "worker_memory" {
  type        = number
  description = "Memory (MiB) for each Locust worker task"
  default     = 2048
}

###
# Deprecated web UI access setting
# The master now runs in headless mode, so this variable has no effect.
###
variable "master_web_ui_cidr_blocks" {
  type        = list(string)
  description = "Deprecated: unused in headless mode."
  default     = []
}
