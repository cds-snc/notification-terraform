#!/bin/bash
NODE_GROUP=$1
NODES=$(kubectl get nodes -l eks.amazonaws.com/nodegroup=$NODE_GROUP | awk 'NR>1{print $1}')

for node in $NODES; do
    echo "Cordoning node $node"
    kubectl cordon $node
    echo "Done."
done
echo "All nodes cordoned"

echo "Begin draining nodes"
for node in $NODES; do
    read -p "Hit <return> when ready to drain $node: " tmp
    echo "Draining node $node"
    kubectl drain $node --ignore-daemonsets  --delete-emptydir-data
    echo "Done."
done
echo "All nodes drained"
