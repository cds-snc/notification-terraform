## Summary

> What is changing and why? (e.g. security patching, scaling API pods, new feature deployment)

## Type of change

- [ ] Infrastructure / module version bump
- [ ] Terraform configuration change (variables, policies, etc.)
- [ ] Dependency or container image update
- [ ] Breaking change (requires downtime or a maintenance window)
- [ ] Other: ___

## Pre-merge checklist

- [ ] Terraform plan output has been reviewed and changes are as expected
- [ ] Changes have been verified in [Notify staging](https://staging.notification.cdssandbox.xyz/)
- [ ] Any risk of downtime or need for a maintenance window has been considered

## Post-merge checklist

- [ ] The `terraform apply` GitHub Actions workflow succeeded
- [ ] Affected AWS resources (ECS services, RDS, Lambda functions, etc.) are healthy
- [ ] Can still log into [Notify production](https://notification.canada.ca)
- [ ] Smoke tests still pass on production
- [ ] Release communicated in the #notify Slack channel

---

<details>
<summary>PR title prefixes (controls versioning on merge)</summary>

| Prefix | Effect |
|---|---|
| `fix:` | Patch release |
| `feat:` | Minor release |
| `BREAKING CHANGE:` | Major release |
| `[AUTO-PR]` | Patch release + auto-deploy to production |
| `chore:` | No release (use for non-app changes like GitHub Actions) |

</details>
