# notification-terraform


### Requires
- Terraform (https://www.terraform.io/)
- Terragrunt (https://terragrunt.gruntwork.io/)

### Why are we using Terragrunt?
The promise of Terragrunt is to make it easier to maintain Terraform code by providing a wrapper around modules, adhering to "Don't repeat yourself" (DRY) configuration as well as better remote state management. For a complete explanation of features, take a look at the [excellent documentation](https://terragrunt.gruntwork.io/docs/#features).

### How is this repository structured?
The terraform code contained in `aws` is split into several independent modules that all use their own remote terraform state file. These modules know nothing about Terragrunt and are used by Terragrunt as simple infrastructure definitions. All the Terraform code in `aws` is environment agnostic, this means, it does not know if it runs in `dev`, `staging`, or `production`. This is achieved through variable interpolations. For example a kubernetes cluster in `staging` requires less powerful compute nodes than in `production`. As a result the kubernetes worker definition contains the `var.primary_worker_instance_types` variable.

The directory structure inside `aws` reflects the split into independent modules. For example, `common`, contains all the networking logic required inside the application, while `eks` and `rds` represent the deployments of the kubernetes cluster and the RDS database. The advantage is that if changes need to be made to infrastructure, should they fail, the state file has less chance of corruption and blast radius is decreased. Additionally, there are significant time gains in running modules independently as the infrastructure dependency graph is limited.

Terragrunt scripts are found in `env`, which defines all the environment specific variables. Contained are subdirectories that define all the terraform modules that should exist in each environment. 

### How are changes applied to the different environments?
Changes are applied through Git merges to this repository. Terragrunt supports the idea of [remote terraform configurations based on tags](https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/#remote-terraform-configurations). This mean we can setup the following continuous integration workflows:

#### Staging
- All pull requests run a `terraform plan` against `staging` and report changes if there are any
- All merges into the `main` branch that touch code in `aws` and `env/staging` run a `terraform apply` against `staging` and update the staging environment. The merge to `main` also tags the commit based on semantic versioning.

#### Production
- The production infrastructure version is updated in [.github/workflows/merge_to_main_production.yml](`.github/workflows/merge_to_main_production.yml`)
- CI detects changes in `env/production` and runs `terraform apply` to apply changes to `production`

#### Necessary additional steps

- [ACM](https://github.com/cds-snc/notification-terraform/blob/main/aws/dns/acm.tf): We do not automatically set the required DNS records to have a valid certificate because the DNS zone is managed on a different account. We had to copy/paste CNAME records to https://github.com/cds-snc/dns/blob/master/terraform/notification.canada.ca-zone.tf 
- [SES](https://github.com/cds-snc/notification-terraform/blob/main/aws/dns/ses.tf): We had to add DNS records for TXT and DKIM validation on the DNS repo as well (Terraform objects `aws_ses_domain_identity` et `aws_ses_domain_dkim`)
- [Load balancer target groups](https://github.com/cds-snc/notification-terraform/blob/main/aws/eks/alb.tf): We needed to put the ARNs on target group files for our Kubernetes cluster in staging [and production](https://github.com/cds-snc/notification-manifests/tree/main/env/production) (Terraform object aws_alb_target_group)
- In order to use [AWS Shield Advanced](https://aws.amazon.com/shield/) we had to click on a button to accept a monthly 3k USD bill/account
- We had to request limits for SES, SNS
- We had to order Pinpoint long code numbers and set the Pinpoint spending limit manually through the console
- We had to extract IAM credentials from the Terraform state in DynamoDB to get AWS keys

#### Helpful commands

Within the Makefile, you can pull the Target Group ARNs using the `get-tg-arns` command

```
# If you would like to specify an environment, it can by done like so
AWS_PROFILE=notify-staging make get-tg-arns
```

### What is each Terraform module

#### `aws/common`
Common networking assets such as:
- VPC 
- Subnets 
- Internet gateway
- NAT gateway
- Route table
- S3 logging buckets
- KMS

#### `aws/dns`
DNS specific outputs for the domain nameserver
- SES DKIM and CNAME validation
- ACM CNAME validation

#### `aws/eks`
Assets to create a working Elastic Kubernetes Service (EKS):
- EKS Controlplane
- EKS Worker groups
- Security groups for Network traffic control
- Application Load Balancer to ingress data into worker nodes

#### `aws/rds`
Assets to create a working Relational Database Service (RDS):
- TBD

#### `aws/cloudfront`
Assets to create to serve static assets on CloudFront CDN.

### How is this different to the existing Notification terraform?
There are a couple of changes compared to the existing Notification terraform:

- We no longer use the third party EKS Terraform module, instead we just use straight up Terraform code
- We no longer use the third party VPC Terraform module, instead we just use straight up Terraform code 
- We make use of all three availability zones in Canada, previously we used two
- We are using an application load balancer to directly access pods in the cluster, previously we used Traefik as a proxy on each node.
- We are using AWS Shield for DDoS protection
- We are using PostgreSQL on Aurora instead of a PostgreSQL database.

### Preliminary architecture diagram
![notify-temp-arch](https://user-images.githubusercontent.com/867334/98271915-7083ba00-1f5e-11eb-82e1-30b188c4dfb9.png)

### Current Module Execution times 

- Common ~ 3 mins
- EKS ~ 18 mins
- RDS ~
