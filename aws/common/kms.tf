data "aws_caller_identity" "current" {}

resource "aws_kms_key" "notification-canada-ca" {
  description         = "notification-canada-ca ${var.env} encryption key"
  enable_key_rotation = true

  # This policy allows encryption/decryption in Cloudwatch
  policy = data.aws_iam_policy_document.encrypted_kms_policy.json

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "aws_iam_policy_document" "encrypted_kms_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_CloudWatch_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_Budgets_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:budgets:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
  statement {
    sid    = "AllowBudgetsServiceToUseKey"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}

resource "aws_kms_key" "notification-canada-ca-us-west-2" {
  provider = aws.us-west-2

  description         = "notification-canada-ca ${var.env} encryption key in us-west-2"
  enable_key_rotation = true

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Id":"key-default-us-west-2",
   "Statement":[
      {
         "Sid":"Enable IAM User Permissions",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
         },
         "Action":"kms:*",
         "Resource":"*"
      },
      {
         "Sid":"Allow_CloudWatch_for_CMK",
         "Effect":"Allow",
         "Principal":{
            "Service":[
               "cloudwatch.amazonaws.com"
            ]
         },
         "Action":[
            "kms:Decrypt",
            "kms:GenerateDataKey"
         ],
         "Resource":"*"
      }
   ]
}
EOF

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}


resource "aws_kms_key" "notification-canada-ca-us-east-1" {
  provider = aws.us-east-1

  description         = "notification-canada-ca ${var.env} encryption key in us-east-1"
  enable_key_rotation = true

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Id":"key-default-us-east-1",
   "Statement":[
      {
         "Sid":"Enable IAM User Permissions",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
         },
         "Action":"kms:*",
         "Resource":"*"
      },
      {
         "Sid":"Allow_CloudWatch_for_CMK",
         "Effect":"Allow",
         "Principal":{
            "Service":[
               "cloudwatch.amazonaws.com"
            ]
         },
         "Action":[
            "kms:Decrypt",
            "kms:GenerateDataKey"
         ],
         "Resource":"*"
      }
   ]
}
EOF

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
