# notification-terraform

### Requires

- Terraform (https://www.terraform.io/)
- Terragrunt (https://terragrunt.gruntwork.io/)

### Why are we using Terragrunt?

The promise of Terragrunt is to make it easier to  maintain Terraform code by providing a wrapper around modules, adhering to "Don't repeat yourself" (DRY) configuration as well as better remote state management. For a complete explanation of features, take a look at the [excellent documentation](https://terragrunt.gruntwork.io/docs/#features).

### How is this repository structured?

The Terraform code contained in `aws` is split into several independent modules that all use their own remote Terraform state file. These modules know nothing about Terragrunt and are used by Terragrunt as simple infrastructure definitions. All the Terraform code in `aws` is environment agnostic, this means, it does not know if it runs in `dev`, `staging`, or `production`. This is achieved through variable interpolations. For example a Kubernetes cluster in `staging` requires less powerful compute nodes than in `production`. As a result the Kubernetes worker definition contains the `var.primary_worker_instance_types` variable.

The directory structure inside `aws` reflects the split into independent modules. For example, `common`, contains all the networking logic required inside the application, while `eks` and `rds` represent the deployments of the Kubernetes cluster and the RDS database. The advantage is that if changes need to be made to infrastructure, should they fail, the state file has less chance of corruption and blast radius is decreased. Additionally, there are significant time gains in running modules independently as the infrastructure dependency graph is limited.

Terragrunt scripts are found in `env`, which defines all the environment specific variables. Contained are subdirectories that define all the Terraform modules that should exist in each environment.

### How do we run terragrunt plan locally?

Running `terragrunt plan` locally (as opposed to through the GitHub actions) can speed up development, in particular to see if your new terraform code is horribly broken. You will need two things:

- AWS credentials: easiest is to have sso and a `notify-staging` aws profile set up.
- the input variables: copy the LastPass file "Notify - terraform.tfvars - Staging" to a local `terraform.tfvars` file, preferable not in a git repo.

Now:

- log into staging sso through your terminal
- go to the module you are interested in, ex: `/env/staging/eks` (note: in `/env/staging`, not `/aws`)
- run

```sh
AWS_PROFILE=notify-staging terragrunt init
AWS_PROFILE=notify-staging terragrunt plan --var-file ~/TEMP/terraform.tfvars
```

**Important notes**:

- you probably shouldn't run `terragrunt apply` from your laptop
- don't plan or apply to production. Don't even bring the variables locally.

### How are changes applied to the different environments?

Changes are applied through Git merges to this repository. Terragrunt supports the idea of [remote Terraform configurations based on tags](https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/#remote-terraform-configurations). This mean we can setup the following continuous integration workflows:

#### Staging

- All pull requests run a `terraform plan` on all modules against `staging` and report changes if there are any
- All merges into the `main` branch that touch code in `aws` and `env/staging` run a `terraform apply` against `staging` and update the staging environment. The merge to `main` also tags the commit based on semantic versioning.

#### Production

- All pull requests run a `terraform plan` on all modules against `production` and report changes if there are any
- The production infrastructure version located at [.github/workflows/infrastructure_version.txt](.github/workflows/infrastructure_version.txt) is manually populated with the `tag` used to deploy to production
- [pull_request.yml](`.github/workflows/pull_request.yml`) and [merge_to_main_production.yml](.github/workflows/merge_to_main_production.yml) use `infrastructure_version.txt` to perform `plan` and `apply`, respectively, to production
- CI detects changes in `env/production` and runs `terraform apply` to apply changes to `production`

#### Necessary additional steps

⚠️ We had to perform some actions on other repositories or manually using the AWS Console. Here is a list of these actions:

- [ACM](https://github.com/cds-snc/notification-terraform/blob/main/aws/dns/acm.tf): We do not automatically set the required DNS records to have a valid certificate because the DNS zone is managed on a different account. We had to copy/paste CNAME records to https://github.com/cds-snc/dns/blob/master/terraform/notification.canada.ca-zone.tf 
- [SES](https://github.com/cds-snc/notification-terraform/blob/main/aws/dns/ses.tf): We had to add DNS records for TXT and DKIM validation on the DNS repo as well (Terraform objects `aws_ses_domain_identity` et `aws_ses_domain_dkim`)
- [Load balancer target groups](https://github.com/cds-snc/notification-terraform/blob/main/aws/eks/alb.tf): We needed to put the ARNs on target group files for our Kubernetes cluster in staging [and production](https://github.com/cds-snc/notification-manifests/tree/main/env/production) (Terraform object aws_alb_target_group)
- In order to use [AWS Shield Advanced](https://aws.amazon.com/shield/) we had to click on a button to accept a monthly 3k USD bill/account
- We had to request limits for SES, SNS
- We had to order Pinpoint long code numbers and set the Pinpoint spending limit manually through the console
- We had to extract IAM credentials from the Terraform state in DynamoDB to get AWS keys

#### Helpful commands

Within the Makefile, you can pull the Target Group ARNs using the `get-tg-arns` command

```sh
# If you would like to specify an environment, it can by done like so
AWS_PROFILE=notify-staging make get-tg-arns
```

### What is each Terraform module

#### `aws/cloudfront`

Assets to create to serve static assets on CloudFront CDN.

#### `aws/common`

Common networking assets such as:

- VPC
- Subnets
- Internet gateway
- NAT gateway
- Route tables
- S3 buckets
- KMS
- CloudWatch
- IAM
- SNS
- Pinpoint
- KMS
- Lambdas

#### `aws/dns`

DNS specific outputs for the domain nameserver

- SES DKIM and CNAME validation
- ACM CNAME validation

#### `aws/eks`

Assets to create a working Elastic Kubernetes Service (EKS):

- EKS control plane
- EKS worker groups
- Security groups for Network traffic control
- Application Load Balancer to ingress data into worker nodes
- Web application firewall

#### `aws/elasticache`

Assets for an Elasticache Redis cluster.

#### `aws/lambda-api`

Assets to create and hook up a lambda function for the api:  the lambda function, an api gateway, and the private container repository (currently required for deploying images into lambda functions).

To add or change environment variables we

- add them to GitHub secrets (both production and staging versions)
  - for example, `PRODUCTION_NEW_VARIABLE` and `STAGING_NEW_VARIABLE`
- add then to the staging and production plan and merge GitHub actions
  - for example, adding lines such as `TF_VAR_new_variable: ${{ secrets.STAGING_NEW_VARIABLE }} to the actions
- add new variable declarations to terraform, by adding to the `variables.tf` file. Be sure to mark any sensitive variables with `sensitive = true`. This should prevent them from being revealed in the Terraform plan.
- add new variables to `lambda.tf` by adding a line such as `NEW_VARIABLE = var.new_variable`

#### `aws/rds`

Assets to create a working Relational Database Service (RDS) using Aurora PostgreSQL.

### Preliminary architecture diagram

![notify-temp-arch](https://user-images.githubusercontent.com/867334/98271915-7083ba00-1f5e-11eb-82e1-30b188c4dfb9.png)
