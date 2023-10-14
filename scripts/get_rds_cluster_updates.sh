#!/bin/bash
set -euo pipefail

#
# Given an RDS cluster name, return the the most recent
# minor version of each major release that is available.
#
# Example:
#   $ ./get_rds_cluster_updates.sh my-rds-cluster
#   11.20, 12.15, 13.9, 14.8, 15.3
#

RDS_CLUSTER_NAME="$1"

CLUSTER="$(aws rds describe-db-clusters \
    --db-cluster-identifier "$RDS_CLUSTER_NAME" \
    --query 'DBClusters[0]')"

CLUSTER_VERSION="$(echo "$CLUSTER" | jq -r .EngineVersion)"
CLUSTER_ENGINE="$(echo "$CLUSTER" | jq -r .Engine)"

AVAILABLE_VERSIONS="$(aws rds describe-db-engine-versions \
    --engine "$CLUSTER_ENGINE" \
    --query 'DBEngineVersions[*].ValidUpgradeTarget[*].{EngineVersion:EngineVersion}' \
    --engine-version "$CLUSTER_VERSION" \
    --no-paginate)"

echo "$AVAILABLE_VERSIONS" | jq -r '.[0] 
    | group_by(.EngineVersion | split(".") | .[0]) 
    | map(max_by(.EngineVersion | split(".") | .[1])) 
    | map(.EngineVersion) 
    | join(", ")'
