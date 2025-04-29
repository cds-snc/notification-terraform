include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_env("ENVIRONMENT") == "production" ? "git::https://github.com/cds-snc/notification-terraform//aws/ecr?ref=v${get_env("INFRASTRUCTURE_VERSION")}" : "../../../aws//ecr"}"

  after_hook "cleanup-admin" {
    commands     = ["apply"]
    execute      = ["rm", "-rfd", "/var/tmp/notification-admin"]
    run_on_error = true
  }

  after_hook "cleanup-api" {
    commands     = ["apply"]
    execute      = ["rm", "-rfd", "/var/tmp/notification-api"]
    run_on_error = true
  }
  after_hook "cleanup-lambdas" {
    commands     = ["apply"]
    execute      = ["rm", "-rfd", "/var/tmp/notification-lambdas"]
    run_on_error = true
  }

}
