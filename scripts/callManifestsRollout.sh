#!/bin/bash
###################################################################################################
# This script is used to call a github action in the notification-manifests repo.                 #
# Pass the argument -a to specify the action to call.                                             #
# Pass the argument -i to specify the inputs. Use ; to deliniate multiple inputs.                 #
#                                                                                                 #
# Example:                                                                                        #
# ./callManifestsRollout.sh -n github-arc-ss                                                      #
#                           -s app=arc,tier=scaleset \                                            #
#                           -t tag=2.7.6                                                          #
###################################################################################################

while getopts 't:s:n:' opt; do
  case "$opt" in
    s)
      SELECTOR=${OPTARG}
      ;;

    t)
      TAG=${OPTARG}
      ;;

    n)
      NAME=${OPTARG}
      ;;

    ?|h)
      echo "Usage: $(basename $0) [-a] [-i]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

PAYLOAD="{\"ref\":\"main\",\"inputs\":{\"app\":\"$NAME\",\"selector\":\"$SELECTOR\",\"tag\":\"$TAG\"}}"

RESPONSE=$(curl -w '%{http_code}\n' \
  -o /dev/null -s \
  -L -X POST -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $WORKFLOW_PAT" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/cds-snc/notification-manifests/actions/workflows/helmfile_staging_apply_specific_app.yaml/dispatches \
  -d "$PAYLOAD")

if [ "$RESPONSE" != 204 ]; then
  echo "ERROR CALLING MANIFESTS ROLLOUT: HTTP RESPONSE: $RESPONSE"
  exit 1
fi
