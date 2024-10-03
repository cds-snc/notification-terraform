resource "aws_kms_key" "rds_snapshot" {
  count                   = var.env == "staging" ? 1 : 0
  description             = "A KMS key for encrypting RDS snapshots"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  policy                  = <<POLICY
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_4085b2fdb6f29f43",
                    "arn:aws:iam::${var.account_id}:role/notification-terraform-apply",
                    "arn:aws:iam::${var.account_id}:role/notification-terraform-plan"
                ]
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion",
                "kms:RotateKeyOnDemand"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_4085b2fdb6f29f43",
                    "arn:aws:iam::${var.account_id}:role/notification-terraform-apply",
                    "arn:aws:iam::${var.account_id}:role/notification-terraform-plan",
                    "arn:aws:iam::${var.dev_account_id}:root"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_4085b2fdb6f29f43",
                    "arn:aws:iam::${var.account_id}:role/notification-terraform-apply",
                    "arn:aws:iam::${var.account_id}:role/notification-terraform-plan",
                    "arn:aws:iam::${var.dev_account_id}:root"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
    POLICY
}