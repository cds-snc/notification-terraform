# see https://docs.aws.amazon.com/sms-voice/latest/userguide/configuration-sets-cloud-watch.html

resource "aws_iam_role" "pinpoint_logs" {
  name               = "PinpointLogs"
  assume_role_policy = data.aws_iam_policy_document.pinpoint_assume.json
}

resource "aws_iam_policy" "pinpoint_logs" {
  count  = var.cloudwatch_enabled ? 1 : 0
  name   = "PinpointLogsPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.pinpoint_logs[0].json
}

resource "aws_iam_role_policy_attachment" "pinpoint_logs" {
  count      = var.cloudwatch_enabled ? 1 : 0
  role       = aws_iam_role.pinpoint_logs.name
  policy_arn = aws_iam_policy.pinpoint_logs[0].arn
}

data "aws_iam_policy_document" "pinpoint_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sms-voice.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:sms-voice:${var.region}:${var.account_id}:configuration-set/pinpoint-configuration"
      ]
    }
  }
}

data "aws_iam_policy_document" "pinpoint_logs" {
  count = var.cloudwatch_enabled ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.pinpoint_deliveries[0].arn}:*",
      "${aws_cloudwatch_log_group.pinpoint_deliveries_failures[0].arn}:*"
    ]
  }
}
