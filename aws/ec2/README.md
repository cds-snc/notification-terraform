# Temporary EC2 Instance

## DEV USE ONLY

This is not part of the regular notify infrastructure.

This deploys a single Isolated EC2 instance to the chosen environment. It is not connected to the notify VPC, but can be used for dev purposes.

Connectivity is achieved through the AWS Console using the [AWS Session Manager](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-with-systems-manager-session-manager.html)
