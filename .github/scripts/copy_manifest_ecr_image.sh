#!/usr/bin/env bash
set -euo pipefail

manifest_file="$1"
region="$2"
repository="$3"
tag_key="$4"
source_account="$5"
target_account="$6"

tag="$(sed -n "s/^${tag_key}:[[:space:]]*\"\([^\"]*\)\"/\1/p" "$manifest_file")"
if [[ ! "$tag" =~ ^[0-9a-f]{7,40}$ ]]; then
  echo "$tag_key must contain a commit SHA; found '$tag'" >&2
  exit 1
fi

source="${source_account}.dkr.ecr.${region}.amazonaws.com/${repository}:${tag}"
target="${target_account}.dkr.ecr.${region}.amazonaws.com/${repository}:${tag}"

if aws ecr describe-images \
  --region "$region" \
  --repository-name "$repository" \
  --image-ids "imageTag=$tag" >/dev/null 2>&1; then
  echo "$repository:$tag already exists in target ECR; skipping copy"
  exit 0
fi

docker pull --platform linux/amd64 "$source"
docker tag "$source" "$target"
docker push "$target"