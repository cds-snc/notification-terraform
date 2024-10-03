include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

terraform {
  source = "git::https://github.com/cds-snc/notification-terraform//aws/ecr?ref=v${get_env("INFRASTRUCTURE_VERSION")}"

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
