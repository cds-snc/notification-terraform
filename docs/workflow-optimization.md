# Terraform Workflow Performance Optimization Guide

## Current Performance Issues Identified:

1. **No Caching**: Each job downloads tools from scratch (5+ minutes per job)
2. **Sequential Dependencies**: Many jobs wait unnecessarily for others
3. **Standard Runners**: Using standard 2-core runners for compute-intensive tasks
4. **Repeated Downloads**: 1Password CLI downloaded 20+ times per workflow
5. **No Terragrunt Cache**: Missing Terragrunt cache between runs

## Recommended Optimizations:

### 1. Use Larger GitHub Runners
Replace `ubuntu-latest` with `ubuntu-latest-4-cores` or `ubuntu-latest-8-cores`:
- 4-core runners: ~50% faster for CPU-intensive tasks
- 8-core runners: ~75% faster for CPU-intensive tasks
- Cost: Slightly higher but worth it for developer productivity

### 2. Add Comprehensive Caching
```yaml
- name: Cache Terraform tools
  uses: actions/cache@v4
  with:
    path: |
      ~/.local/bin
      ~/.terraform.d
      ~/terraform-tools
    key: terraform-tools-${{ runner.os }}-${{ hashFiles('.github/actions/setup-terraform/action.yml') }}

- name: Cache 1Password CLI  
  uses: actions/cache@v4
  with:
    path: /usr/local/bin/op
    key: 1password-cli-${{ runner.os }}

- name: Cache Terragrunt
  uses: actions/cache@v4
  with:
    path: |
      ~/.terragrunt-cache
      .terragrunt-cache
    key: terragrunt-cache-${{ runner.os }}-${{ hashFiles('**/terragrunt.hcl', '**/*.tf') }}
```

### 3. Optimize Job Dependencies
Current issues:
- `terragrunt-plan-ses_receiving_emails` waits for `terragrunt-plan-ecr-us-east` (unnecessary)
- Many jobs could run in parallel but are artificially serialized

Recommended dependency matrix:
```
Level 1 (Parallel): common, ecr, ecr-us-east, dns
Level 2 (Depends on Level 1): elasticache, rds, eks
Level 3 (Depends on Level 2): lambda-*, ses-*, sns-*, system-status
Level 4 (Final): cloudfront, github
```

### 4. Use Matrix Strategy for Similar Jobs
Instead of 20+ individual jobs, group similar components:
```yaml
strategy:
  matrix:
    component: [ses_receiving_emails, ses_to_sqs_email_callbacks, sns_to_sqs_sms_callbacks]
```

### 5. Terraform Provider Caching
Add to terragrunt.hcl:
```hcl
terraform {
  extra_arguments "providers_cache" {
    commands = ["init", "plan", "apply"]
    env_vars = {
      TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache"
    }
  }
}
```

### 6. Pre-build Docker Images
Create custom runner images with tools pre-installed:
- Terraform, Terragrunt, 1Password CLI pre-installed
- Reduces setup time from 2-3 minutes to 30 seconds

## Expected Performance Improvements:

| Current | Optimized | Improvement |
|---------|-----------|-------------|
| 15-20 minutes total | 8-12 minutes | ~40-50% faster |
| 5+ min per job setup | 1-2 min per job | ~60-70% faster |
| 25+ parallel jobs | 15-20 jobs | Better resource usage |

## Implementation Priority:

1. **High Impact, Easy**: Add caching (immediate 2-3x speedup)
2. **High Impact, Medium**: Use 4-core runners  
3. **Medium Impact, Medium**: Optimize dependencies
4. **High Impact, Hard**: Matrix strategies and custom images

## GitHub Runner Performance Context:

GitHub hasn't specifically "lowered" runner performance, but:
- Increased demand can cause slower provisioning
- Network latency to download tools varies
- Terraform/Terragrunt downloads are inherently slow
- Each job doing full setup is inefficient

The 5+ minute setup time you're seeing is mostly due to:
- Tool downloads: ~2-3 minutes
- AWS credential setup: ~30 seconds  
- Terragrunt init: ~1-2 minutes
- Plan execution: ~1-3 minutes

With caching, setup drops to ~30-60 seconds per job.