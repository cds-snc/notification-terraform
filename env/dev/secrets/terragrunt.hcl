terraform {
  source = "../../../aws//secrets"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../rds", "../elasticache", "../eks"]
}

dependency "eks" {
  config_path = "../eks"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    api_target_group_arn =  "12345"
    admin_target_group_arn =  "12345"
    document_api_target_group_arn =  "12345"
    documentation_target_group_arn =  "12345"
    document_target_group_arn =  "12345"
    eks_cluster_endpoint = "endpoint"
  }
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
  api_target_group_arn =  dependency.eks.outputs.api_target_group_arn
  admin_target_group_arn =  dependency.eks.outputs.admin_target_group_arn
  document_api_target_group_arn =  dependency.eks.outputs.document_api_target_group_arn
  documentation_target_group_arn =  dependency.eks.outputs.document_api_target_group_arn
  document_target_group_arn =  dependency.eks.outputs.document_target_group_arn
  eks_cluster_endpoint = dependency.eks.outputs.eks_cluster_endpoint

}
