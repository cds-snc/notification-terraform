terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/manifest_secrets?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//manifest_secrets"}"
}

dependencies {
  paths = ["../rds", "../elasticache"]
}

dependency "rds" {
  config_path = "../rds"
}

dependency "elasticache" {
  config_path = "../elasticache"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  database_read_only_proxy_endpoint = dependency.rds.outputs.database_read_only_proxy_endpoint
  database_read_write_proxy_endpoint = dependency.rds.outputs.database_read_write_proxy_endpoint
  postgres_rds_instance_id = dependency.rds.outputs.rds_instance_id
  redis_cluster_security_group_id = dependency.elasticache.outputs.redis_cluster_security_group_id
}
