#!/bin/bash
# This script is used to clean up load balacers that are not terminated by terraform since they are controlled by EKS.
# Delete internal load balancers
ELBS=$(aws elb describe-load-balancers --query 'LoadBalancerDescriptions[].LoadBalancerName' --output text)
for elb in $ELBS; do
  echo "Deleting ELB $elb"
  aws elb delete-load-balancer --load-balancer-name $elb
  echo "Done."
done