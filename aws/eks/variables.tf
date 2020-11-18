variable aws_acm_notification_canada_ca_arn {
  type = string
}

variable aws_acm_alt_notification_canada_ca_arn {
  type = string
}

variable primary_worker_desired_size {
  type = number
}

variable primary_worker_instance_types {
  type = list
}

variable primary_worker_max_size {
  type = number
}

variable primary_worker_min_size {
  type = number
}

variable vpc_id {
  type = string
}

variable vpc_private_subnets {
  type = list
}

variable vpc_public_subnets {
  type = list
}

variable sns_alert_warning_arn {
  type = string
}

variable sns_alert_critical_arn {
  type = string
}
