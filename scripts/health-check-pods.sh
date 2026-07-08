#!/bin/bash

set -e

# Configuration
DEPLOYMENT_NAME="notify-api"
PORT=6011
HEALTH_ENDPOINT="/"
TIMEOUT=5
WAIT_TIME=3

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Fetching pods for deployment: $DEPLOYMENT_NAME"

# Get all pod names for the deployment
PODS=$(kubectl get pods -l app=$DEPLOYMENT_NAME -o jsonpath='{.items[*].metadata.name}')

if [ -z "$PODS" ]; then
    echo -e "${RED}No pods found for deployment: $DEPLOYMENT_NAME${NC}"
    exit 1
fi

# Convert to array
POD_ARRAY=($PODS)
TOTAL_PODS=${#POD_ARRAY[@]}

echo -e "Found ${GREEN}$TOTAL_PODS${NC} pod(s)\n"

SUCCESS_COUNT=0
FAILURE_COUNT=0

# Loop through each pod
for POD in "${POD_ARRAY[@]}"; do
    echo -e "${YELLOW}=== Checking pod: $POD ===${NC}"
    
    # Start port-forward in the background
    kubectl port-forward pod/$POD $PORT:$PORT > /dev/null 2>&1 &
    PF_PID=$!
    
    echo "Started port-forward (PID: $PF_PID)"
    echo "Waiting $WAIT_TIME seconds for port-forward to establish..."
    sleep $WAIT_TIME
    
    # Check if port-forward is still running
    if ! ps -p $PF_PID > /dev/null; then
        echo -e "${RED}✗ Port-forward failed to start${NC}\n"
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
        continue
    fi
    
    # Perform health check
    echo "Performing health check on localhost:$PORT$HEALTH_ENDPOINT"
    
    if curl -s -f --max-time $TIMEOUT http://localhost:$PORT$HEALTH_ENDPOINT > /dev/null; then
        echo -e "${GREEN}✓ Health check passed${NC}"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo -e "${RED}✗ Health check failed${NC}"
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
    fi
    
    # Kill the port-forward process
    echo "Stopping port-forward..."
    kill $PF_PID 2>/dev/null || true
    wait $PF_PID 2>/dev/null || true
    
    # Give it a moment before moving to the next pod
    sleep 1
    echo ""
done

# Summary
echo -e "${YELLOW}=== Summary ===${NC}"
echo -e "Total pods checked: $TOTAL_PODS"
echo -e "${GREEN}Successful: $SUCCESS_COUNT${NC}"
echo -e "${RED}Failed: $FAILURE_COUNT${NC}"

if [ $FAILURE_COUNT -eq 0 ]; then
    echo -e "\n${GREEN}All health checks passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some health checks failed!${NC}"
    exit 1
fi
