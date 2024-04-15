#!/bin/bash

# Usage:
# . sanitize_sms_usage_logs.sh input_bucket output_bucket
#
# Description:
# This script sanitizes the SMS usage logs by removing the DestinationPhoneNumber from each file in the input bucket and uploading the sanitized files to the output bucket

# from 
# https://stackoverflow.com/questions/63111258/how-can-i-process-every-file-in-my-s3-bucket-with-bash


if [ -z "$1" ]; then
    echo "Please provide the input bucket name"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please provide the output bucket name"
    exit 1
fi
inbucket=$1
outbucket=$2

echo "Processing files in $inbucket"
objects=$(aws s3api list-objects \
            --bucket $inbucket \
            --output json        \
            --query "Contents[].Key")

for file in $(echo $objects | jq -r '.[]'); do
    if [[ $file == *".gz" ]]; then
        echo "Processing $file"
        aws s3 cp s3://$inbucket/$file ${file}
        gunzip ${file};
        csvFile=${file%.gz}
        cut -f -2,4- -d, $csvFile > ${csvFile}_out
        mv ${csvFile}_out $csvFile
        gzip $csvFile
        aws s3 cp $file s3://$outbucket/$file
        rm $file
    fi 
done  

