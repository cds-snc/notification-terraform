###
# AWS Cloud Map — private DNS so Locust workers can resolve the master
# Workers connect to master.locust.local:5557
###

resource "aws_service_discovery_private_dns_namespace" "locust" {
  name        = "locust.local"
  description = "Private DNS namespace for Locust redline load testing"
  vpc         = aws_vpc.locust.id

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_service_discovery_service" "locust_master" {
  name = "master"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.locust.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
