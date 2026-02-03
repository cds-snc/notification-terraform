# S3 bucket for Velero backups
resource "aws_s3_bucket" "velero_backups" {
  bucket = "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}-velero-backups"

  tags = {
    Name = "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}-velero-backups"
  }
}

resource "aws_s3_bucket_versioning" "velero_backups" {
  bucket = aws_s3_bucket.velero_backups.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "velero_backups" {
  bucket = aws_s3_bucket.velero_backups.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "velero_backups" {
  bucket = aws_s3_bucket.velero_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "velero_backups" {
  bucket = aws_s3_bucket.velero_backups.id

  eventbridge = true
}

resource "aws_s3_bucket_lifecycle_configuration" "velero_backups" {
  bucket = aws_s3_bucket.velero_backups.id

  rule {
    id     = "expire-old-backups"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# IAM policy for Velero
resource "aws_iam_policy" "velero" {
  name        = "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}-velero-policy"
  description = "Policy for Velero backup and restore operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = [
          "${aws_s3_bucket.velero_backups.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.velero_backups.arn
        ]
      }
    ]
  })
}

# IAM role for Velero service account
resource "aws_iam_role" "velero" {
  name = "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}-velero-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.notification-canada-ca.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub" = "system:serviceaccount:velero:velero-server"
            "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}-velero-role"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "velero" {
  role       = aws_iam_role.velero.name
  policy_arn = aws_iam_policy.velero.arn
}

# Outputs
output "velero_s3_bucket_name" {
  description = "Name of the S3 bucket for Velero backups"
  value       = aws_s3_bucket.velero_backups.id
}

output "velero_iam_role_arn" {
  description = "ARN of the IAM role for Velero"
  value       = aws_iam_role.velero.arn
}

output "velero_s3_bucket_arn" {
  description = "ARN of the S3 bucket for Velero backups"
  value       = aws_s3_bucket.velero_backups.arn
}