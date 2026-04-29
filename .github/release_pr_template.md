## What happens when your PR merges?

- Prefix the title of your PR:
  - `fix:` - tag `main` as a new patch release
  - `feat:` - tag `main` as a new minor release
  - `BREAKING CHANGE:` - tag `main` as a new major release
  - `[AUTO-PR]` - tag `main` as a new patch release and deploy to production
  - `chore:` - use for changes to non-app code (ex: GitHub actions)

## What are you changing?

- [ ] Releasing a new infrastructure version
- [ ] Changing Terraform configuration

## Provide some background on the changes

> Give details ex. Security patching, content update, more API pods etc

## Checklist before merging

- [ ] I have verified that the changes are as expected in [Notify staging](https://staging.notification.cdssandbox.xyz/)
- [ ] I am aware of any infrastructure changes that may cause downtime or require a maintenance window

## After merging this PR

- [ ] I have verified that the `terraform apply` GitHub Actions workflow succeeded
- [ ] I have verified that affected AWS resources (ECS services, RDS, Lambda functions, etc.) are healthy
- [ ] I have verified that I can still log into [Notify production](https://notification.canada.ca)
- [ ] I have verified that the smoke tests still pass on production
- [ ] I have communicated the release in the #notify Slack channel
