import os
import re

from email.utils import parseaddr


def parse_recipients(headers):
    SENDING_DOMAIN = os.environ['NOTIFY_SENDING_DOMAIN']

    # Gather recipients from our own domain only
    recipients = headers.get("to", []) + headers.get("cc", []) + headers.get("bcc", [])
    recipients = [parseaddr(r)[1] for r in recipients]

    return [r for r in recipients if r.endswith(f"@{SENDING_DOMAIN}")]


def lambda_handler(event, context):
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
        source = payload["mail"]["source"]
        parsed = parseaddr(source)[1]
        if parsed == '':
            print(f"Error: could not parse source {source}")
        source = parsed

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
            f"Received email addressed to {recipients} from {source} with subject {subject} in reply to {messageId}"
        )

    return {
        'statusCode': 200,
    }
