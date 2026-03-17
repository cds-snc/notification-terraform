include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/ecr-us-west-2?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//ecr-us-west-2"}"

  after_hook "cleanup-lambdas" {
    commands     = ["apply"]
    execute      = ["rm", "-rfd", "/var/tmp/notification-lambdas"]
    run_on_error = true
  }

}
