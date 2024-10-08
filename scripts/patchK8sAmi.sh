#!/bin/bash
# This script will accept a new K8s node image name, lookup the AMI ID, and patch it in the eks terragrunt.hcl file for a list of given environments
# Usage: ./patchK8sAmi.sh <env> <new_image_version>
# Example: ./patchK8sAmi.sh dev,staging 1.30.2-20240828
# Example: ./patchK8sAmi.sh prod 1.30.2-20240828
ENVIRONMENTS=$1
NEW_IMAGE_VERSION=$2

# Get the AMI ID for the new image
K8S_VERISON=$(echo $NEW_IMAGE_VERSION | cut -c1-4)
echo "Detected K8s Version of: $K8S_VERISON"
NODE_VERSION=$(echo $NEW_IMAGE_VERSION | rev | cut -c1-8 | rev)
echo "Detected Node Version of: $NODE_VERSION"
NEW_IMAGE_NAME="amazon-eks-node-$K8S_VERISON-v$NODE_VERSION"
echo "Looking up AMI ID for $NEW_IMAGE_NAME"
NEW_AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=$NEW_IMAGE_NAME" --query 'Images[].ImageId' --output text)
echo "New AMI ID is: $NEW_AMI_ID"

# Set the Internal Field Separator to comma
IFS=','

# Iterate over each environment
for ENV in $ENVIRONMENTS; do
  echo "Patching env vars file for $ENV"
  
  if [ $ENV != "production" ]; then 
    VAULT=4eyyuwddp6w4vxlabrr2i2duxm
  else
    VAULT=ppnxsriom3alsxj4ogikyjxlzi
  fi

  pushd ../aws
  op read op://$VAULT/"TFVars - $ENV"/notesPlain > $ENV.tfvars.temp

  sed -E -i '' "s/[0-9].[0-9]{2}.[0-9]*-[0-9]{8}/$NEW_IMAGE_VERSION/" $ENV.tfvars.temp
  sed -E -i '' "s/ami-[A-Fa-f0-9]+/$NEW_AMI_ID/" $ENV.tfvars.temp

  if op item edit "TFVars - $ENV" notesPlain="$(cat $ENV.tfvars.temp)" > /dev/null ; then
    echo "Done."
  else
    echo "WARNING: UPDATE FAILED"
  fi
  mv $ENV.tfvars.temp $ENV.tfvars
  popd 
done