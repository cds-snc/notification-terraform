# Running Production DNS Changes Locally

## Overview

The production DNS Terraform module uses a cross-account IAM role (`notify_prod_dns_manager`) to manage Route 53 records. This role can only be assumed by the `notification-terraform-apply` role in the management account.

When running `terragrunt plan/apply` locally, your AWS SSO session is not authorized to assume `notify_prod_dns_manager` directly. To work around this, you need to temporarily patch the trust policy of `notification-terraform-apply` to allow your account to assume it, then assume that role in your shell session before running Terraform.

## Prerequisites

- AWS CLI configured with SSO (`AWSAdministratorAccess` permission set)
- `jq` installed (`brew install jq`)
- An active AWS SSO session for the management account, set as your active profile:
  ```bash
  export AWS_PROFILE=<your-notify-management-profile>
  aws sso login --profile $AWS_PROFILE
  ```

> **Note:** The scripts do not accept a `--profile` flag. They use whichever AWS CLI profile is active in your shell (`AWS_PROFILE` env var or the default profile). Make sure you have the correct account's profile active before running them.

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
1. Verifies your current identity and reverts the `notification-terraform-apply` trust policy **before** unsetting credentials, ensuring the right account is targeted
2. Unsets the `AWS_*` environment variables from your shell

## Why This Is Necessary

In normal CI operation, GitHub Actions assumes `notification-terraform-apply` via OIDC (`sts:AssumeRoleWithWebIdentity`). That role is then authorized to chain-assume `notify_prod_dns_manager` in the production account.

AWS SSO role ARNs (e.g. `arn:aws:iam::ACCOUNT:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_*`) can be referenced in IAM identity-based policies (such as KMS key policies), but AWS rejects them as principals in IAM role **trust policies** with an `Invalid principal` error. The account root is therefore used as a temporary trust principal, which delegates access control to the identity-based policies attached to the SSO role.

The trust policy patch should never be left in place permanently — always run `source scripts/revokeDnsRole.sh` when done.