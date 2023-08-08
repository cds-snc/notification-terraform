# Cordon and Drain a Node

Sometimes we want to move all work off a node so that we can replace it with one with a different architecture or settings. This is done in two steps:
- First we **cordon** the node. This tells k8s to stop scheduling new application pods on that node. Pods currently running are unaffected.
- Next we **drain** the node. Each application pod is started on another node, and the corresponding pod on our cordoned node is killed.

## Procedure

- From a local machine with administrator account access to AWS, run the cordonAndDrain_node.sh script in the scripts directory, passing in the name of the node you wish to cordon and drain.

    Example:
    ``` ./cordonAndDrain_node.sh ip-10-0-0-70.ca-central-1.compute.internal ```
- Verify that the script has run successfully:
    - Check that the node is marked as "Ready, Scheduling Disabled"
    - Check that all pods in notification-canada-ca are newly created and running on another node. Effectively, no notification-canada-ca pods should be running on the node, but the total number of pods in the system should stay the same.
