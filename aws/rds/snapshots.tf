# resource "aws_kms_key" "rds_snapshot" {
#   count                   = var.env == "staging" ? 1 : 0
#   description             = "A KMS key for encrypting/decrypting RDS snapshots"
#   enable_key_rotation     = true
#   deletion_window_in_days = 7
#   policy                  = <<POLICY
# {
#     "Id": "key-consolepolicy-3",
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "Enable IAM User Permissions",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::${var.account_id}:root"
#             },
#             "Action": "kms:*",
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow access for Key Administrators",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": [
#                     "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_4085b2fdb6f29f43",
#                     "arn:aws:iam::${var.account_id}:role/notification-terraform-apply",
#                     "arn:aws:iam::${var.account_id}:role/notification-terraform-plan"
#                 ]
#             },
#             "Action": [
#                 "kms:Create*",
#                 "kms:Describe*",
#                 "kms:Enable*",
#                 "kms:List*",
#                 "kms:Put*",
#                 "kms:Update*",
#                 "kms:Revoke*",
#                 "kms:Disable*",
#                 "kms:Get*",
#                 "kms:Delete*",
#                 "kms:TagResource",
#                 "kms:UntagResource",
#                 "kms:ScheduleKeyDeletion",
#                 "kms:CancelKeyDeletion",
#                 "kms:RotateKeyOnDemand"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow use of the key",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": [
#                     "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_4085b2fdb6f29f43",
#                     "arn:aws:iam::${var.account_id}:role/notification-terraform-apply",
#                     "arn:aws:iam::${var.account_id}:role/notification-terraform-plan",
#                     "arn:aws:iam::${var.dev_account_id}:root"
#                 ]
#             },
#             "Action": [
#                 "kms:Encrypt",
#                 "kms:Decrypt",
#                 "kms:ReEncrypt*",
#                 "kms:GenerateDataKey*",
#                 "kms:DescribeKey"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow attachment of persistent resources",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": [
#                     "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_4085b2fdb6f29f43",
#                     "arn:aws:iam::${var.account_id}:role/notification-terraform-apply",
#                     "arn:aws:iam::${var.account_id}:role/notification-terraform-plan",
#                     "arn:aws:iam::${var.dev_account_id}:root"
#                 ]
#             },
#             "Action": [
#                 "kms:CreateGrant",
#                 "kms:ListGrants",
#                 "kms:RevokeGrant"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "Bool": {
#                     "kms:GrantIsForAWSResource": "true"
#                 }
#             }
#         }
#     ]
# }
#     POLICY
# }

# data "aws_db_cluster_snapshot" "latest" {
#     count = var.env == "staging" ? 1 : 0
#     db_cluster_identifier = aws_rds_cluster.notification-canada-ca.id
#     snapshot_type = "automated"
#     most_recent = true
# }

# resource "null_resource" "delete_existing_snapshot" {
#     count = var.env == "staging" ? 1 : 0
    
#     provisioner "local-exec" {
#         command = <<EOT
#         SNAPSHOT_EXISTS=$(aws rds describe-db-cluster-snapshots --db-cluster-snapshot-identifier "pond-snapshot-staging-to-dev-test" --query "length(DBClusterSnapshots)" --output text 2>/dev/null || echo "0")
#         if [ "$SNAPSHOT_EXISTS" != "0" ]; then
#             echo "Deleting existing snapshot 'pond-snapshot-staging-to-dev-test'..."
#             aws rds delete-db-cluster-snapshot --db-cluster-snapshot-identifier "pond-snapshot-staging-to-dev-test"
#         fi
#         EOT
#     }
    
#     depends_on = [data.aws_db_cluster_snapshot.latest]
# }

# resource "aws_rds_cluster_snapshot_copy" "custom_snapshot" {
#     count = var.env == "staging" ? 1 : 0
#     source_db_cluster_snapshot_identifier = data.aws_db_cluster_snapshot.latest[0].id
#     target_db_cluster_snapshot_identifier = "pond-snapshot-staging-to-dev-test"
#     kms_key_id = aws_kms_key.rds_snapshot[0].arn
#     depends_on = [null_resource.delete_existing_snapshot, data.aws_db_cluster_snapshot.latest]
# }

# locals {
#     snapshot_id_to_share = var.env == "staging" && length(aws_rds_cluster_snapshot_copy.custom_snapshot) > 0 ? aws_rds_cluster_snapshot_copy.custom_snapshot[0].id : null
# }

# resource "null_resource" "share_snapshot" {
#     count = var.env == "staging" ? 1 : 0
#     triggers = {
#         snapshot_id = local.snapshot_id_to_share
#     }
    
#     provisioner "local-exec" {
#         command = <<EOT
#         aws rds modify-db-cluster-snapshot-attribute \
#           --db-cluster-snapshot-identifier ${local.snapshot_id_to_share} \
#           --attribute-name restore \
#           --values-to-add ${var.dev_account_id}
#         EOT
#     }
    
#     depends_on = [aws_rds_cluster_snapshot_copy.custom_snapshot]
# }
