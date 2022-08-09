resource "aws_cloudwatch_dashboard" "redis_batch_saving" {
  dashboard_name = "Redis-batch-saving"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 9,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_published", "list_name", "inbox:email:priority" ],
                    [ "...", "inbox:email:normal" ],
                    [ "...", "inbox:email:bulk" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Added to email inboxes"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 0,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_published", "list_name", "inbox:sms:priority" ],
                    [ "...", "inbox:sms:normal" ],
                    [ "...", "inbox:sms:bulk" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Added to sms inboxes"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "email", "created", "True", "priority", "priority", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Priority email inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "email", "created", "True", "priority", "normal", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Normal email inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "email", "created", "True", "priority", "bulk", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Bulk email inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 12,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "sms", "created", "True", "priority", "priority", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Priority sms inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 12,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "sms", "created", "True", "priority", "normal", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Normal sms inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 12,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "sms", "created", "True", "priority", "bulk", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Bulk sms inflights"
            }
        },
        {
            "height": 13,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "# Description\n- Overview of notifications entering the system. This dashboard is meant to show the internal of the redis queues.\n- This dashboard shows us notifications which have not yet been saved to the database\n- NOTE: only notifications sent using the API are included here (`/sms` or `/email`).  \n- NOTE: Admin requests and posting to `/bulk` are not here.\n\n# Definitions\n- Inbox: a redis list that is the first entry of notifications into the system\n- Inflight: a subset of the inbox list that is about to be added to the database\n   - created: a group of messages taken out of the inbox and put together\n   - acknowledged: inflight notification has been added to our database and scheduled to be processed\n   - expired:  something went wrong and the inflight was never acknowledged (notification goes back to inbox)\n\n# Additional information\n- [Priority lanes adr](https://github.com/cds-snc/notification-adr/blob/main/records/2022-03-08.priority-lanes.md)\n\n# Todo\n- keeping track of oldest message in a particular queue (when it was added the first time vs. bouncing back and forth from inbox/inflights)"
            }
        }
    ]
}
EOF
}
