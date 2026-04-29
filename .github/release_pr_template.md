## What happens when this PR merges?

Merging this PR deploys the infrastructure version listed below to **production** via `terraform apply`.

## Infrastructure version being deployed

> Give details ex. Security patching, content update, more API pods etc

## Pre-merge checklist | Liste de vérification avant fusion

- [ ] I have reviewed the changes included in this release and they are as expected.
- [ ] I have verified that the staging environment is healthy before promoting to production.
- [ ] I am aware of any infrastructure changes that may cause downtime or require a maintenance window.
- [ ] This PR does not raise new security concerns. Refer to our GC Notify Risk Register document on our Google drive.

## After merging this PR | Après la fusion

- [ ] I have verified that the `terraform apply` GitHub Actions workflow succeeded.
- [ ] I have verified that affected AWS resources (ECS services, RDS, etc.) are healthy.
- [ ] I have verified that I can still log into [Notify production](https://notification.canada.ca).
- [ ] I have verified that the smoke tests still pass on production.
- [ ] I have communicated the release in the #notify Slack channel if it may impact users.
