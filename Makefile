aws-staging-common:
	cd env/staging/common &&\
	terragrunt apply --terragrunt-non-interactive

aws-staging-eks:
	cd env/staging/eks &&\
	terragrunt apply --terragrunt-non-interactive

aws-staging-common-dev:
	cd env/staging/common &&\
	terragrunt validate --terragrunt-non-interactive

aws-staging-eks-dev:
	cd env/staging/eks &&\
	terragrunt validate --terragrunt-non-interactive

fmt:
	terraform fmt -recursive aws && terragrunt hclfmt
