# S3 Bucket Size Calculator

This project contains a Python script and a GitHub Action workflow to calculate
the total size and number of items in specified S3 buckets. The results are
logged in a CSV file stored in an S3 bucket.

## Overview

The script performs the following steps:
1. Retrieves the list of S3 bucket names from the environment variables `BUCKET_NAMES`
   and `OUTPUT_BUCKET`. These can also be stored in an .env file.
2. Calculates the total size and number of objects in each specified S3 bucket.
3. Appends the calculated sizes and item counts along with the current date to a CSV file.
4. Checks if the CSV file already exists in the specified output S3 bucket (defined by the `OUTPUT_BUCKET` environment variable).
5. If the CSV file exists, downloads it, appends the new data, and uploads the updated file back to the S3 bucket.
6. If the CSV file does not exist, creates a new CSV file with the new data and uploads it to the S3 bucket.

## Environment Variables

- `BUCKET_NAMES`: A comma-separated list of S3 bucket names to calculate the total size and item count for.
- `OUTPUT_BUCKET`: The name of the S3 bucket where the CSV file will be saved.

## CSV File Format

The CSV file contains the following columns:

- Date
- BucketName
- SizeInBytes
- ItemCount

Example CSV Content:

```
Date,BucketName,SizeInBytes,ItemCount
2023-10-01T00:00:00,example-bucket-1,123456789,1000
2023-10-01T00:00:00,example-bucket-2,987654321,2000
```

## Usage

### Running the Script Locally

1. Install Poetry:
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```

2. Initialize the project and install dependencies:
   ```bash
   cd /workspaces/notification-terraform/scripts/s3bucketsize
   poetry install
   ```

3. Set the required environment variables:
   ```bash
   export BUCKET_NAMES="example-bucket-1,example-bucket-2"
   export OUTPUT_BUCKET="output-bucket"
   ```

4. Run the script:
   ```bash
   poetry run python s3bucketsize.py
   ```

## GitHub Actions Workflow

The GitHub Actions workflow is set up to run the script daily at midnight and upload the CSV file to the specified S3 bucket.

## Secrets Configuration

Ensure you have the following secrets configured in your GitHub repository:

* `BUCKET_NAMES`: Comma-separated list of S3 bucket names.
* `OUTPUT_BUCKET`: The name of the S3 bucket where the CSV file will be saved.

This setup will ensure that your script's dependencies are managed by Poetry and that the GitHub Actions workflow installs and uses these dependencies correctly.
