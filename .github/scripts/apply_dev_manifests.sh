#!/usr/bin/env bash
set -eo pipefail

phase="${1:-}"
case "$phase" in
  bootstrap|application) ;;
  *) printf 'Expected bootstrap or application phase.\n' >&2; exit 2 ;;
esac

cd notification-manifests/helmfile
source ./getContext.sh

if [[ "$phase" == "bootstrap" ]]; then
  for stage in 0 1 2 3 4; do
    helmfile -e dev -l "step=$stage" apply --wait
  done
  kubectl --context dev wait --for=condition=Established --timeout=120s \
    crd/secretproviderclasses.secrets-store.csi.x-k8s.io \
    crd/targetgroupbindings.elbv2.k8s.aws
else
  helmfile -e dev -l step=5 apply --wait
fi