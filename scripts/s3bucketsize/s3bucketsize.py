"""
This Python script calculates the total size of items in specified S3
buckets and logs the results in a CSV file.

The function runs once per day and performs the following steps:

1. Retrieves the list of S3 bucket names from the environment variable 
   `BUCKET_NAMES`.
2. Calculates the total size of objects in each specified S3 bucket.
3. Appends the calculated sizes along with the current date to a CSV file.
4. Checks if the CSV file already exists in the specified output S3 bucket
   (defined by the `OUTPUT_BUCKET` environment variable).
5. If the CSV file exists, downloads it, appends the new data, and uploads the
   updated file back to the S3 bucket.
6. If the CSV file does not exist, creates a new CSV file with the new data and
   uploads it to the S3 bucket.

Environment Variables:
- BUCKET_NAMES: A comma-separated list of S3 bucket names to calculate the
  total size for.
- OUTPUT_BUCKET: The name of the S3 bucket where the CSV file will be saved.

CSV File Format:
- The CSV file contains the following columns: Date, BucketName, SizeInBytes.

Example CSV Content:
Date, BucketName, SizeInBytes
2023-10-01T00:00:00,example-bucket-1,123456789
2023-10-01T00:00:00,example-bucket-2,987654321
"""

import csv
import os
from datetime import datetime
import boto3
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def main():
    s3 = boto3.client("s3")
    bucket_names = os.environ["BUCKET_NAMES"].split(",")
    output_bucket = os.environ["OUTPUT_BUCKET"]

    print(f"Calculating sizes for buckets: {bucket_names}")
    print(f"Output will be saved to bucket: {output_bucket}")

    # Prepare CSV data headers
    csv_data = [["Date", "BucketName", "SizeInBytes", "ItemCount"]]

    for bucket_name in bucket_names:
        print(f"Processing bucket: {bucket_name}")
        # Calculate the total size of the bucket
        total_size = 0
        item_count = 0
        for obj in s3.list_objects_v2(Bucket=bucket_name)["Contents"]:
            # print(f"Object: {obj['Key']}, Size: {obj['Size']} bytes")
            total_size += obj["Size"]
            item_count += 1

        print(f"Bucket: {bucket_name}, Size: {total_size} bytes, Items: {item_count}")
        # Append data for each bucket
        csv_data.append([datetime.now().isoformat(), bucket_name, total_size, item_count])

    # Define the CSV file path in S3
    csv_file_key = "buckets-size.csv"
    local_csv_file = "/tmp/bucket_size.csv"

    # Check if the CSV file exists in S3
    try:
        s3.head_object(Bucket=output_bucket, Key=csv_file_key)
        file_exists = True
        print(f"CSV file {csv_file_key} exists in bucket {output_bucket}. Downloading...")
    except s3.exceptions.ClientError:
        file_exists = False
        print(f"CSV file {csv_file_key} does not exist in bucket {output_bucket}. Creating new file...")

    if file_exists:
        # Download the existing CSV file
        s3.download_file(output_bucket, csv_file_key, local_csv_file)
        
        with open(local_csv_file, "a", newline="", encoding="utf-8") as file:
            writer = csv.writer(file)
            # Append new data (excluding header)
            writer.writerows(csv_data[1:])
        print(f"Appended new data to existing CSV file.")
    else:
        # Create a new CSV file
        with open(local_csv_file, "w", newline="", encoding="utf-8") as file:
            writer = csv.writer(file)
            writer.writerows(csv_data)
        print(f"Created new CSV file with data.")

    # Upload the updated or new CSV file back to S3
    s3.upload_file(local_csv_file, output_bucket, csv_file_key)
    print(f"Uploaded CSV file to bucket {output_bucket} with key {csv_file_key}.")


if __name__ == "__main__":
    main()
