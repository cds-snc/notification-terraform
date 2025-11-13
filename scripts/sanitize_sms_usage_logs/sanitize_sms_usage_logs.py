import os
from io import BytesIO

import argparse
import pandas as pd
import boto3
from pathlib import Path

from dotenv import load_dotenv


def main():
    load_dotenv()
    parser=argparse.ArgumentParser()
    parser.add_argument("in_bucket", help="input bucket")
    parser.add_argument("out_bucket", nargs='?', help="output bucket")
    parser.add_argument("--push", help="push output to s3 (default: save locally instead)", action="store_true", default=False)
    args = parser.parse_args()
        
    session = boto3.Session()
    s3 = session.resource('s3')
    
    if args.in_bucket is None:
        raise ValueError("Input bucket is required")
    in_bucket = s3.Bucket(args.in_bucket)

    for key in [csv_file.key for csv_file in list(in_bucket.objects.all()) if csv_file.key.endswith(".gz") or csv_file.key.endswith(".csv")]:
        print(f"\nProcessing {key}")
        df = pd.read_csv(f"s3://{args.in_bucket}/{key}").sort_values(by="PublishTimeUTC")
        df = df.drop(columns=["DestinationPhoneNumber"], errors='ignore')
        df = df.drop_duplicates(subset=['MessageId'], keep='last')
        df["PriceInUSDPerFragment"] = df.PriceInUSD / df.TotalParts
        
        if args.push:
            if args.out_bucket is None:
                raise ValueError("Output bucket is required when pushing to s3")
            csv_buffer = BytesIO()
            df.to_csv(csv_buffer, index=False, compression={'method': 'gzip'})
            s3.Object(args.out_bucket, key).put(Body=csv_buffer.getvalue(), ContentEncoding='gzip')
            print(f"Pushed to s3://{args.out_bucket}/{key}")
        else:
            directory = os.path.dirname(key)
            Path(directory).mkdir(parents=True, exist_ok=True)
            df.to_csv(f"./{key}", index=False)
            print(f"Saved to {key}")

if __name__ == "__main__":
    main()
