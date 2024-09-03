#!/bin/bash
# This script is used to clean up spot instances that are not terminated by terraform since they are controlled by Karpenter.

# Clean up Spot instances
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)

# Clean up lingering network interfaces
GROUP=$(aws ec2 describe-security-groups --query 'SecurityGroups[].GroupId' --filter 'Name=group-name,Values=eks-cluster-sg-notification-canada-ca-dev-eks-cluster*' --output text) 
INSTANCES=$(aws ec2 describe-network-interfaces --query 'NetworkInterfaces[*].NetworkInterfaceId' --filters Name=group-id,Values=$GROUP --output text)
for instance in $INSTANCES; do
  echo "Deleting network interface $instance"
  aws ec2 delete-network-interface --network-interface-id $instance
  echo "Done."
done
