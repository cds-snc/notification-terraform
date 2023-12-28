terraform {
  source = "../../../aws//secrets"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../rds", "../elasticache"]
}

dependency "rds" {
  config_path = "../rds"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    postgres_host = "rds.endpoint.1234.com"
    database_read_only_proxy_endpoint = "test1234"
    datbase_name = "test"
  }
}

dependency "elasticache" {
  config_path = "../elasticache"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    redis_url = "redis.endpoint.com"
  }
}

inputs = {
  postgres_host = dependency.rds.outputs.rds_endpoint
  database_read_only_proxy_endpoint = dependency.rds.outputs.database_read_only_proxy_endpoint
  database_read_write_proxy_endpoint = dependency.rds.outputs.database_read_write_proxy_endpoint
  database_name = dependency.rds.outputs.database_name
  redis_url = dependency.elasticache.outputs.primary_endpoint_address
}
