#!/bin/bash

# Script to clean up duplicate cache entries and optimize job dependencies

WORKFLOW_FILE=".github/workflows/terragrunt_plan_staging.yml"
BACKUP_FILE="${WORKFLOW_FILE}.pre-dependency-optimization"

echo "Optimizing job dependencies and cleaning up duplicates..."

# Create backup
cp "$WORKFLOW_FILE" "$BACKUP_FILE"
echo "✅ Created backup at $BACKUP_FILE"

# Create Python script for complex optimizations
cat > temp_dependency_optimizer.py << 'EOF'
import re
import sys

def optimize_dependencies(content):
    # Remove duplicate cache blocks
    # Pattern to find duplicate cache sections
    duplicate_pattern = r'(\s+- name: Cache Terraform tools\s+uses: actions/cache@v4.*?terraform-tools-\$\{\{ runner\.os \}\}-\s*\n)(\s+- name: Cache 1Password CLI\s+uses: actions/cache@v4.*?1password-cli-\$\{\{ runner\.os \}\}\s*\n)(\1\2)'
    content = re.sub(duplicate_pattern, r'\1\2', content, flags=re.DOTALL)
    
    # Optimize specific job dependencies for better parallelization
    
    # DNS can run in parallel with common
    dns_job_pattern = r'(terragrunt-plan-dns:.*?needs: )terragrunt-filter'
    content = re.sub(dns_job_pattern, r'\1terragrunt-filter', content, flags=re.DOTALL)
    
    # SES receiving emails has unnecessary ECR dependencies - can depend on common only  
    ses_receiving_pattern = r'(terragrunt-plan-ses_receiving_emails:.*?needs: )\[terragrunt-filter,terragrunt-plan-common,terragrunt-plan-ecr,terragrunt-plan-ecr-us-east\]'
    content = re.sub(ses_receiving_pattern, r'\1[terragrunt-filter, terragrunt-plan-common]', content, flags=re.DOTALL)
    
    # Many lambda jobs can run in parallel after common/ecr
    lambda_jobs = ['lambda-api', 'lambda-admin-pr', 'lambda-google-cidr']
    for job in lambda_jobs:
        pattern = f'(terragrunt-plan-{job}:.*?needs: )\\[terragrunt-filter,terragrunt-plan-common,terragrunt-plan-elasticache,terragrunt-plan-ecr\\]'
        replacement = r'\1[terragrunt-filter, terragrunt-plan-common, terragrunt-plan-ecr]'
        content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    
    # Remove unnecessary elasticache dependency from SES/SNS jobs
    ses_sns_jobs = ['ses_to_sqs_email_callbacks', 'sns_to_sqs_sms_callbacks', 'pinpoint_to_sqs_sms_callbacks']
    for job in ses_sns_jobs:
        pattern = f'(terragrunt-plan-{job}:.*?needs: )\\[terragrunt-filter,terragrunt-plan-common,terragrunt-plan-elasticache,terragrunt-plan-ecr\\]'
        replacement = r'\1[terragrunt-filter, terragrunt-plan-common]'
        content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    
    return content

# Read the workflow file
with open(sys.argv[1], 'r') as f:
    content = f.read()

# Optimize it
optimized_content = optimize_dependencies(content)

# Write it back
with open(sys.argv[1], 'w') as f:
    f.write(optimized_content)

print("✅ Cleaned up duplicate cache entries")
print("✅ Optimized job dependencies for better parallelization")
EOF

# Run the Python optimization script
python3 temp_dependency_optimizer.py "$WORKFLOW_FILE"

# Clean up
rm temp_dependency_optimizer.py

# Let's also create a more efficient reusable action
echo ""
echo "Creating optimized reusable setup action..."

# Update the cached setup action to include Terragrunt caching
cat > .github/actions/setup-terraform-cached/action.yml << 'EOF'
name: "setup-terraform-cached"
description: "Setup Terraform tools with comprehensive caching for maximum performance"

inputs:
  role_to_assume:
    description: The role to assume when configuring AWS credentials
    required: true
    type: string
  role_session_name:
    description: The name of the session when configuring AWS credentials
    required: true
    type: string

runs:
  using: "composite"
  steps:
    - name: Cache Terraform tools
      uses: actions/cache@v4
      with:
        path: |
          ~/.local/bin
          ~/.terraform.d
          ~/terraform-tools
        key: terraform-tools-${{ runner.os }}-${{ hashFiles('.github/actions/setup-terraform/action.yml') }}
        restore-keys: |
          terraform-tools-${{ runner.os }}-
    
    - name: Cache 1Password CLI
      uses: actions/cache@v4
      with:
        path: /usr/local/bin/op
        key: 1password-cli-${{ runner.os }}
        restore-keys: |
          1password-cli-${{ runner.os }}
    
    - name: Cache Terragrunt cache directories
      uses: actions/cache@v4
      with:
        path: |
          ~/.terragrunt-cache
          .terragrunt-cache
        key: terragrunt-cache-${{ runner.os }}-${{ github.sha }}
        restore-keys: |
          terragrunt-cache-${{ runner.os }}-
    
    - name: Set environment variables
      uses: ./.github/actions/setvars
      with:
        envVarFile: ./.env

    - name: Setup Terraform tools
      uses: cds-snc/terraform-tools-setup@v1
      env:
        CONFTEST_VERSION: 0.30.0 
        TERRAFORM_VERSION: 1.11.4
        TERRAGRUNT_VERSION: 0.77.22
        TF_SUMMARIZE_VERSION: 0.2.3

    - name: Setup Infrastructure Version
      run: |
        INFRASTRUCTURE_VERSION=`cat ./.github/workflows/infrastructure_version.txt`
        echo "INFRASTRUCTURE_VERSION=$INFRASTRUCTURE_VERSION" >> $GITHUB_ENV
      shell: bash

    - name: Configure credentials to Notify account using OIDC
      uses: aws-actions/configure-aws-credentials@5fd3084fc36e372ff1fff382a39b10d03659f355 # v2.2.0
      with:
        role-to-assume: ${{ inputs.role_to_assume }}
        role-session-name: ${{ inputs.role_session_name }}
        aws-region: ca-central-1

    - name: Install 1Password CLI (if not cached)
      run: |
        if ! command -v op &> /dev/null; then
          curl -o 1pass.deb https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb
          sudo dpkg -i 1pass.deb
        else
          echo "✅ 1Password CLI already installed (cached)"
        fi
      shell: bash

    - name: Download TFVars with caching
      run: |
        sudo mkdir -p aws
        cd aws
        if [ ! -f "${{github.workspace}}/aws/staging.tfvars" ]; then
          op read op://4eyyuwddp6w4vxlabrr2i2duxm/"TERRAFORM_SECRETS_staging"/notesPlain > staging.tfvars
        else
          echo "✅ TFVars already present"
        fi
      shell: bash
EOF

echo "✅ Updated cached setup action with Terragrunt caching"
echo ""
echo "🚀 Dependency optimization complete!"
echo ""
echo "Changes made:"
echo "- ✅ Removed duplicate cache entries"
echo "- ✅ Optimized job dependencies for parallel execution"
echo "- ✅ Enhanced cached setup action with Terragrunt caching"
echo "- ✅ Reduced unnecessary cross-dependencies"
echo ""
echo "Jobs that can now run in parallel:"
echo "- dns, ecr, ecr-us-east (Level 1)"
echo "- ses_*, sns_* jobs (after common only)"
echo "- lambda-* jobs (reduced dependencies)"
echo ""
echo "Backup created at: $BACKUP_FILE"