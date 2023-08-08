#!/bin/bash
NODE=$1
echo "Cordoning node $NODE ..."
kubectl cordon $NODE
echo "Done."

echo "Begin draining $NODE"
kubectl drain $NODE --ignore-daemonsets  --delete-emptydir-data
echo "Done."
