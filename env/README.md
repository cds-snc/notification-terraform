# GC NOTIFY DEV ENVIRONMENT

## Pre-requisites
In addition to terraform and terragrunt, you must install the 1Password CLI Tool and then [configure the CLI to work with the desktop application](https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration)
1. Install CLI
  ```shell
  brew install 1password-cli
  ```
2. [Configure the CLI to work with the desktop application as per these instructions](https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration)

## Running Terraform in Dev Locally

With the above, you can run terraform locally in dev.

### First run

The first time you run, Terraform will fail, because it will not have the dev.tfvars file. When it errors out, you should be able to simply re-run your original command.

### Where is the TFVars file?

The dev.tfvars file will automatically be downloaded to notification-terraform/aws/dev.tfvars. 

### Command Examples

To run against dev, ensure your AWS profile is dev.

1. Switch to an env/dev/<resource> directory
    ```shell
    cd env/dev/eks 
    ```
2. Terraform plan:
    ```shell
    terragrunt plan -var-file ../dev.tfvars 
    ```
3. Terraform apply:
    ```shell
    terragrunt apply -var-file ../dev.tfvars 
    ```
4. Terraform apply to a specific target:
    ```shell
    terragrunt apply --target resource_type.resource_name -var-file ../dev.tfvars 
    ex:
    terragrunt apply --target aws_eks_cluster.notification-canada-ca-eks-cluster -var-file ../dev.tfvars 
    ```
### Modifying Dev TFVars

If you need to modify or add a new argument in dev, open the dev.tfvars in notification-terraform/aws/dev.tfvars and make and save your changes.

When you next run terragrunt plan or apply, you will be prompted if you would like to sync the changes in 1Password. As a general rule of thumb only type "yes" if you are applying (i.e. you intend to keep this change).

Your changes will be automatically sync'ed when you type yes.
