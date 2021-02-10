import json
import base64
import boto3
import uuid
import os
import re
from email.utils import parseaddr

SENDING_DOMAIN = os.environ['NOTIFY_SENDING_DOMAIN']
SQS_REGION = os.environ['SQS_REGION']
CELERY_QUEUE_PREFIX = os.environ['CELERY_QUEUE_PREFIX']
CELERY_QUEUE = 'notify-internal-tasks'
CELERY_TASK_NAME = 'send-notify-no-reply'


def to_queue(queue, data):
    task = {
        "task": CELERY_TASK_NAME,
        "id": str(uuid.uuid4()),
        "args": [json.dumps(data)],
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
                "routing_key": CELERY_QUEUE,
            },
            "body_encoding": "base64",
            "delivery_tag": str(uuid.uuid4())
        }
    }
    msg = base64.b64encode(bytes(json.dumps(envelope), 'utf-8')).decode("utf-8")
    queue.send_message(MessageBody=msg)


def parse_recipients(headers):
    # Gather recipients from our own domain only
    recipients = headers.get("to", []) + headers.get("cc", []) + headers.get("bcc", [])
    recipients = [parseaddr(r)[1] for r in recipients]

    return [r for r in recipients if r.endswith(f"@{SENDING_DOMAIN}")]


def lambda_handler(event, context):
    sqs = boto3.resource('sqs', region_name=SQS_REGION)
    queue = sqs.get_queue_by_name(QueueName=f"{CELERY_QUEUE_PREFIX}{CELERY_QUEUE}")

    # See the payload documentation
    # https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-action-lambda-event.html
    # https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-notifications-contents.html
    for record in event["Records"]:
        payload = record["ses"]
        spam_verdict = payload["receipt"]["spamVerdict"]
        virus_verdict = payload["receipt"]["virusVerdict"]

        # Check for potential spam or virus and do not reply
        if spam_verdict == "FAIL" or virus_verdict == "FAIL":
            return {'statusCode': 200}

        # Get the sender
        sender = payload["mail"]["source"]
        parsed = parseaddr(sender)[1]
        if parsed == '':
            print(f"Error: could not parse sender {sender}. Stopping.")
            return {'statusCode': 200}
        sender = parsed

        # Get the subject
        subject = payload["mail"]["commonHeaders"]["subject"]

        # Get the optional messageId (UUID v4) they replied to
        messageId = None
        matches = re.search(
            r"([0-9a-f]{8}\-[0-9a-f]{4}\-4[0-9a-f]{3}\-[89ab][0-9a-f]{3}\-[0-9a-f]{12})",
            payload["mail"]["commonHeaders"]["messageId"],
            re.IGNORECASE
        )
        if matches:
            messageId = matches.groups()[0]

        recipients = parse_recipients(payload["mail"]["commonHeaders"])

        print(f"Full payload {payload}")
        print(
            f"Received email addressed to {recipients} from {sender} with subject {subject} in reply to {messageId}"
        )

        to_queue(queue, {
            'messageId': messageId,
            'recipients': recipients,
            'sender': sender,
            'subject': subject,
        })

    return {
        'statusCode': 200,
    }
