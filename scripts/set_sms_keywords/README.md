# set_sms_keywords.py

This script manages SMS keywords for AWS Pinpoint phone numbers and pools, specifically for GC Notify. It allows you to set, validate, and update keyword actions and messages for both English and French keywords.

## Features

- Sets keywords and their messages for phone numbers and pools in AWS Pinpoint.
- Validates SMS message lengths and warns if messages will be split into multiple parts.
- Supports both English and French keywords and actions (e.g., OPT_IN, OPT_OUT, AUTOMATIC_RESPONSE).
- Can run in validation-only mode to check message lengths without making changes to AWS.

## Prerequisites

- Python 3.7+
- AWS credentials configured (via environment variables, AWS CLI, or `.env` file)
- Required Python packages: `boto3`, `python-dotenv`

Install dependencies:

```bash
pip install boto3 python-dotenv
```

## Virtual Environment Setup

A virtual environment is included in this directory. To activate it:

**On macOS/Linux:**

```bash
source venv/bin/activate
```

To deactivate the virtual environment when you're done:

```bash
deactivate
```

**Note:** Make sure to activate the virtual environment before running the script to ensure you're using the correct Python packages.

## Usage

Navigate to the script directory:

```bash
cd scripts/set_sms_keywords
```

Run the script with one or more options. You must specify the AWS region to update using the required `--region` parameter. Only `us-west-2` or `ca-central-1` are accepted.


### Validate keyword messages only (no changes to AWS)

```bash
python set_sms_keywords.py --region ca-central-1 --validate-only
```

### Set keywords for all Pinpoint pools

```bash
python set_sms_keywords.py --region us-west-2 --pools
```

### Set keywords for phone numbers not in a pool

```bash
python set_sms_keywords.py --region ca-central-1 --phone-numbers
```

### Combine options

You can combine options to update both pools and phone numbers:

```bash
python set_sms_keywords.py --region us-west-2 --pools --phone-numbers
```

## Options

- `--region` (required): AWS region to update (`us-west-2` or `ca-central-1`).
- `--pools` : Change keywords of all Pinpoint pools.
- `--phone-numbers` : Change keywords of phone numbers not in a pool.
- `--validate-only` : Validate keyword messages without submitting changes to AWS.

## Environment Variables

You can use a `.env` file to set AWS credentials and region. Example:

```sh
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=ca-central-1
```

## Notes

- The script will warn if any keyword message exceeds SMS length limits and will be split into multiple parts.
- Make sure your AWS user has permissions for Pinpoint SMS operations.
