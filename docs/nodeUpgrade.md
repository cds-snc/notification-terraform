# How To Upgrade EKS Nodes
## Pre-Requisites
#### Validation
Before running these steps in production or staging, they should be first run against a scratch account to validate that the upgrade is successful.

#### Access

Administrator access to the AWS accounts from a developer machine is required.

#### Instance Types
A valid node instance type and size to upgrade to needs to be known. This can be determined via click-ops in the AWS Console:
    
- Open the AWS Console
- Navigate to the EKS (Elastic Kubernetes Service) Page
- Click on the existing cluster
- Click on the "Compute" tab
- Scroll down to Node Groups and click "Add Node Grouop"
- Provide a dummy name - ex: "Test"
- Select the existing eks-worker-role under Node IAM role
- Click Next
- You will then be able to click the drop down box on "instance types" to see the available node instance types. Choose the one most appropriate for the upgrade [Go Here for Instance Descriptions](https://aws.amazon.com/ec2/instance-types/)

## Procedure Steps

#### Secondary Node Group Creation

When upgrading a node group instance type, the node group must be destroyed and recreated. To ensure there is no downtime for the application an interim secondary node group must be created, and the workload migrated to this.

- In env/\<environment>/eks/terragrunt.hcl, set the nodeUpgrade variable to **true**
- Set the secondary_worker_instance_types variable to the target node instance type. Ex "m6i.large"
- Commit these changes, and create a PR
- Validate in the PR that a new node group will be created and that none will be destroyed
- Merge the PR
- Verify that the new nodes are created (kubectl get nodes)

#### Migrate Workload to Secondary Node Group

- From a local machine with administrator account access to AWS, run the cordonAndDrain.sh script in the scripts directory, passing in the name of the **primary** node group  
    Example:
    ``` ./cordonAndDrain_nodeGroup.sh notification-canada-ca-scratch-eks-primary-node-group ```
- Verify that the script has run successfully:
    - Check that the old nodes are marked as "Ready, Scheduling Disabled"
    - Check that all pods in notification-canada-ca are newly created and running on the **secondary** node group (kubectl describe pod ...)

#### Upgrade Primary Nodes

- In env/\<environment>/eks/terragrunt.hcl, set the primary_worker_instance_types variable to the target node instance type. Ex "m6i.large"
- Commit these changes, and create a PR
- Validate in the PR that the primary node group will be re-created (1 to create, 1 to destroy)
- Merge the PR
- Verify that the primary nodes are removed then re-created (kubectl get nodes)

#### Migrate Workload back to Primary Node Group

- From a local machine with administrator account access to AWS, run the cordonAndDrain.sh script in the scripts directory, passing in the name of the **secondary** node group  
    Example:
    ``` ./cordonAndDrain_nodeGroup.sh notification-canada-ca-scratch-eks-secondary-node-group ```
- Verify that the script has run successfully:
    - Check that the old nodes are marked as "Ready, Scheduling Disabled"
    - Check that all pods in notification-canada-ca are newly created and running on the **primary** node group (kubectl describe pod ...)

#### Remove Secondary Node Group

- In env/\<environment>/eks/terragrunt.hcl, set the nodeUpgrade variable to **false**
- Commit these changes, and create a PR
- Validate in the PR that a secondary node group will be destroyed
- Merge the PR
- Verify that the secondary nodes are removed (kubectl get nodes)