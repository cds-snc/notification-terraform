# Running Production DNS Changes Locally

## Overview

The production DNS Terraform module uses a cross-account IAM role (`notify_prod_dns_manager`) to manage Route 53 records. This role can only be assumed by the `notification-terraform-apply` role in the management account.

When running `terragrunt plan/apply` locally, your AWS SSO session is not authorized to assume `notify_prod_dns_manager` directly. To work around this, you need to temporarily patch the trust policy of `notification-terraform-apply` to allow your account to assume it, then assume that role in your shell session before running Terraform.

## Prerequisites

- AWS CLI configured with SSO (`AWSAdministratorAccess` permission set)
- `jq` installed (`brew install jq`)
- An active AWS SSO session (`aws sso login --profile <profile>`)

## Running a DNS Plan/Apply

### Step 1 — Enable local access and assume the role

Source the setup script from the root of the repository. It must be **sourced** (not executed) so the credentials are exported into your current shell:

```bash
source scripts/assumeDnsRole.sh
```

This script:
1. Patches the `notification-terraform-apply` trust policy to allow the management account root to assume it
2. Assumes the `notification-terraform-apply` role and exports `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN` into your shell

### Step 2 — Run your Terraform command

Navigate to the relevant environment directory and run your plan or apply as normal:

```bash
cd env/production/dns
terragrunt plan
```

### Step 3 — Revoke access when done

Once finished, **always** run the cleanup script to remove the trust policy patch and unset your credentials. This must also be sourced:

```bash
source scripts/revokeDnsRole.sh
```

This script:
1. Unsets the `AWS_*` environment variables from your shell
2. Removes the account root statement from the `notification-terraform-apply` trust policy, restoring it to its original state

## Why This Is Necessary

In normal CI operation, GitHub Actions assumes `notification-terraform-apply` via OIDC (`sts:AssumeRoleWithWebIdentity`). That role is then authorized to chain-assume `notify_prod_dns_manager` in the production account. AWS SSO roles cannot be directly referenced in trust policies, so the account root is used as a temporary principal to bridge the gap for local use.

The trust policy patch should never be left in place permanently — always run `source scripts/revokeDnsRole.sh` when done.