resource "aws_cloudwatch_dashboard" "inflights_dashboard" {
  dashboard_name = "Inflights"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 0,
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
            "y": 0,
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
            "y": 0,
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
            "y": 6,
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
            "y": 6,
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
            "y": 6,
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
        }
    ]
}
EOF
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}




