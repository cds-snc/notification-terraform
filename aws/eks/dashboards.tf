resource "aws_cloudwatch_dashboard" "elb" {
  dashboard_name = "Elastic-Load-Balancers"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 5,
            "width": 8,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Request Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 0,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP 5XX Count",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 0,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Active Connection Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 5,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "ClientTLSNegotiationErrorCount", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Client TLS Negotiation Error Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 5,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "ConsumedLCUs", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Average", "id": "m0r0" } ]
                ],
                "title": "Consumed LC Us Average",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 5,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTP_Fixed_Response_Count", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Fixed Response Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 10,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTP_Redirect_Count", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Redirect Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 10,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTP_Redirect_Url_Limit_Exceeded_Count", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Redirect Url Limit Exceeded Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 10,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_3XX_Count", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Code ELB 3 XX Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 15,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP 4XX Count",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 15,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "IPv6ProcessedBytes", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "I Pv 6 Processed Bytes Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 15,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "IPv6RequestCount", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "I Pv 6 Request Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 20,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "NewConnectionCount", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "New Connection Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 20,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Processed Bytes Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 20,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "RejectedConnectionCount", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Rejected Connection Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 24,
            "y": 25,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "ca-central-1",
                "metrics": [
                    [ "AWS/ApplicationELB", "RuleEvaluations", "LoadBalancer", "app/notification-${var.env}-alb/${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Rule Evaluations Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        }
    ]
}
EOF
}