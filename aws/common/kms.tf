data "aws_caller_identity" "current" {}

resource "aws_kms_key" "notification-canada-ca" {
  description         = "notification-canada-ca ${var.env} encryption key"
  enable_key_rotation = true

  # This policy allows encryption/decryption in Cloudwatch
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.${var.region}.amazonaws.com" },
      "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow_CloudWatch_for_CMK",
      "Effect": "Allow",
      "Principal": {
          "Service":[
              "cloudwatch.amazonaws.com"
          ]
      },
      "Action": [
          "kms:Decrypt","kms:GenerateDataKey"
      ],
      "Resource": "*"
    },
    {
    "Effect": "Allow",
    "Principal": {
      "Service": "ses.amazonaws.com"
    },
    "Action": [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ],
    "Resource": "*"
  },
  {
    "Sid": "Allow_Budgets_for_CMK",
    "Effect": "Allow",
    "Principal": {
      "Service": "budgets.amazonaws.com"
    },
    "Action": [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ],
    "Resource": "*",
    "Condition": {
      "StringEquals": {
        "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
      },
      "ArnLike": {
        "aws:SourceArn": "arn:aws:budgets::${data.aws_caller_identity.current.account_id}:*"
      }
    }
  }

  ]
}
EOF

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
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
      },
      {
         "Sid":"Allow_SQS_for_CMK",
         "Effect":"Allow",
         "Principal":{
            "Service":"sqs.amazonaws.com"
         },
         "Action":[
            "kms:GenerateDataKey*",
            "kms:Decrypt"
         ],
         "Resource":"*"
      },
      {
         "Sid":"Allow_Budgets_for_CMK",
         "Effect":"Allow",
         "Principal":{
            "Service":"budgets.amazonaws.com"
         },
         "Action":[
            "kms:GenerateDataKey*",
            "kms:Decrypt"
         ],
         "Resource":"*",
         "Condition":{
            "StringEquals":{
               "aws:SourceAccount":"${data.aws_caller_identity.current.account_id}"
            },
            "ArnLike":{
               "aws:SourceArn":"arn:aws:budgets::${data.aws_caller_identity.current.account_id}:*"
            }
         }
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
      },
      {
         "Sid":"Allow_SQS_for_CMK",
         "Effect":"Allow",
         "Principal":{
            "Service":"sqs.amazonaws.com"
         },
         "Action":[
            "kms:GenerateDataKey*",
            "kms:Decrypt"
         ],
         "Resource":"*"
      },
      {
         "Sid":"Allow_Budgets_for_CMK",
         "Effect":"Allow",
         "Principal":{
            "Service":"budgets.amazonaws.com"
         },
         "Action":[
            "kms:GenerateDataKey*",
            "kms:Decrypt"
         ],
         "Resource":"*",
         "Condition":{
            "StringEquals":{
               "aws:SourceAccount":"${data.aws_caller_identity.current.account_id}"
            },
            "ArnLike":{
               "aws:SourceArn":"arn:aws:budgets::${data.aws_caller_identity.current.account_id}:*"
            }
         }
      }
   ]
}
EOF

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
