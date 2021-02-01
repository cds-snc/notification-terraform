import base64
import json
import boto3
import uuid


def lambda_handler(event, context):
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(
        QueueName='eks-notification-canada-cadelivery-receipts'
    )

    for record in event["Records"]:
        task = {
            "task": "process-ses-result",
            "id": str(uuid.uuid4()),
            "args": [
                {
                    "Message": record["Sns"]["Message"]
                }
            ],
            "kwargs": {},
            "retries": 0,
            "eta": None,
            "expires": None,
            "utc": True,
            "callbacks": None,
            "errbacks": None,
            "timelimit": [
                None,
                None
            ],
            "taskset": None,
            "chord": None
        }
        envelope = {
            "body": base64.b64encode(bytes(json.dumps(task), 'utf-8')).decode("utf-8"),
            "content-encoding": "utf-8",
            "content-type": "application/json",
            "headers": {},
            "properties": {
                "reply_to": str(uuid.uuid4()),
                "correlation_id": str(uuid.uuid4()),
                "delivery_mode": 2,
                "delivery_info": {
                    "priority": 0,
                    "exchange": "default",
                    "routing_key": "delivery-receipts"
                },
                "body_encoding": "base64",
                "delivery_tag": str(uuid.uuid4())
            }
        }
        msg = base64.b64encode(bytes(json.dumps(envelope), 'utf-8')).decode("utf-8")
        queue.send_message(MessageBody=msg)

    return {
        'statusCode': 200
    }
