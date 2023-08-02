#!/bin/bash
NODE_GROUP=$1
NODES=$(kubectl get nodes -l eks.amazonaws.com/nodegroup=$NODE_GROUP | awk 'NR>1{print $1}')
echo "Begin cordoning nodes"
while IFS= read -r node; do
    echo "Cordoning node $node"
    kubectl cordon $node
    echo "Done."
done <<< "$NODES"
echo "All nodes cordoned"
echo "Begin draining nodes"
while IFS= read -r node; do
    echo "Cordoning node $node"
    kubectl drain $node --ignore-daemonsets  --delete-emptydir-data
    echo "Done."
done <<< "$NODES"
echo "All nodes drained"

