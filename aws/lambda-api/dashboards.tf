resource "aws_cloudwatch_dashboard" "api-lambda" {
  dashboard_name = "API-Lambda"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 7,
            "width": 23,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApiGateway", "Count" ],
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "app/notification-${var.env}-alb/${var.alb_arn_suffix}", { "yAxis": "right" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 60,
                "title": "API Gateway vs ALB Traffic",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "label": "API Gateway"
                    },
                    "right": {
                        "min": 0,
                        "label": "notification-${var.env}-alb"
                    }
                }
            }
        }
    ]
}
EOF
}