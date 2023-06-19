resource "aws_cloudwatch_dashboard" "database" {
  dashboard_name = "Database"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 15,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "explorer",
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ReadLatency",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "DatabaseConnections",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "FreeableMemory",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ReadThroughput",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ReadIOPS",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "WriteLatency",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "WriteThroughput",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "WriteIOPS",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    }
                ],
                "labels": [
                    {
                        "key": "CostCenter"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "stacked": false,
                    "rowsPerPage": 50,
                    "widgetsPerRow": 2
                },
                "period": 300,
                "splitBy": "",
                "region": "ca-central-1",
                "title": ""
            }
        }
    ]
}
EOF
}