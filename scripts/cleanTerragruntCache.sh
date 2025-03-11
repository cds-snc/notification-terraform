#!/bin/bash
for dir in ../env/dev/*/     # list directories in the form "/tmp/dirname/"
do
    pushd $dir
    echo "Cleaning terragrunt cache in $dir"
    rm -rf .terragrunt-cache
    popd
done