#!/bin/bash
SG=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --output text)
for group in $SG; do
  echo "Deleting Security Group $group"
  aws ec2 delete-security-group --group-id $group
  echo "Done."
done