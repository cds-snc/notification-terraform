terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/manifest_secrets?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//manifest_secrets"}"
}

dependencies {
  paths = ["../rds", "../elasticache"]
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    database_read_only_proxy_endpoint = "thisisamockstring_database_read_only_proxy_endpoint"
    database_read_write_proxy_endpoint = "thisisamockstring_database_read_write_proxy_endpoint"
    postgres_cluster_endpoint = "thisisamockstring_postgres_cluster_endpoint"
  }
}

dependency "elasticache" {
  config_path = "../elasticache"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    redis_primary_endpoint_address = "thisisamockstring_redis_primary_endpoint_address"
    elasticache_queue_cache_primary_endpoint_address = "thisisamockstring_elasticache_queue_cache_primary_endpoint_address"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  database_read_only_proxy_endpoint = dependency.rds.outputs.database_read_only_proxy_endpoint
  database_read_write_proxy_endpoint = dependency.rds.outputs.database_read_write_proxy_endpoint
  postgres_cluster_endpoint = dependency.rds.outputs.postgres_cluster_endpoint
  redis_primary_endpoint_address = dependency.elasticache.outputs.redis_primary_endpoint_address
  elasticache_queue_cache_primary_endpoint_address = dependency.elasticache.outputs.elasticache_queue_cache_primary_endpoint_address
}
