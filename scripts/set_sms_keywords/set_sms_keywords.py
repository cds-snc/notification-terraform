import os

import json
import argparse
import boto3

from dotenv import load_dotenv


def main():
    load_dotenv()
    parser=argparse.ArgumentParser()
    args = parser.parse_args()
        
    # session = boto3.Session(aws_access_key_id=os.environ.get("AWS_ACCESS_KEY_ID"), aws_secret_access_key=os.environ.get("AWS_SECRET_ACCESS_KEY"))
    
    # pinpoint = session.resource('pinpoint-sms-voice-v2')

    pinpoint = boto3.client('pinpoint-sms-voice-v2', region_name='ca-central-1')
    
    phone_numbers = pinpoint.describe_phone_numbers()

    for phone_number in phone_numbers['PhoneNumbers']:
        if phone_number.get('PoolId') is None:
            id = phone_number['PhoneNumberId']
            pinpoint.
            keywords = pinpoint.describe_keywords(OriginationIdentity=id)['Keywords']
            print(json.dumps(keywords, indent=4))


if __name__ == "__main__":
    main()
