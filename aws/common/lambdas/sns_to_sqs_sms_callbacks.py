import gzip
import json
import base64
import boto3
import uuid
import os


def to_queue(queue, message):
    task = {
        "task": "process-sns-result",
        "id": str(uuid.uuid4()),
        "args": [
            {
                "Message": message
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
    print(f'Sending task {task}')
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


def lambda_handler(event, context):
    cw_data = event['awslogs']['data']
    compressed_payload = base64.b64decode(cw_data)
    uncompressed_payload = gzip.decompress(compressed_payload)
    payload = json.loads(uncompressed_payload)

    log_events = payload['logEvents']

    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName="eks-notification-canada-cadelivery-receipts")

    for log_event in log_events:
        print(f'LogEvent: {log_event}')
        to_queue(queue, log_event['message'])

    return {
        'statusCode': 200
    }
