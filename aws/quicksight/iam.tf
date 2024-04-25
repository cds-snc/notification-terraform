
##### Quicksight connect to RDS

resource "aws_iam_role" "quicksight" {
  name = "quicksight"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "quicksight.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "quicksight-rds" {
  name        = "rds-access"
  description = "Allow access to RDS"
  policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds-db:connect",
          "rds:Describe*",
          "rds:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds-qs-attach" {
  role       = aws_iam_role.quicksight.name
  policy_arn = aws_iam_policy.quicksight-rds.arn
}

resource "aws_iam_policy" "quicksight-s3-usage" {
  name        = "s3-usage"
  description = "Allow access to S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-qs-attach" {
  role       = aws_iam_role.quicksight.name
  policy_arn = aws_iam_policy.quicksight-s3-usage.arn
}

resource "null_resource" "db_setup" {
  provisioner "local-exec" {
    command = "psql -c \"SET password_encryption = 'md5';\" -c \"CREATE ROLE quicksight_db_user WITH LOGIN PASSWORD '$QSPASS';\" -c \"GRANT rds_superuser TO quicksight_db_user;\" -h ${var.database_read_write_proxy_endpoint_host} -p 5432 -U postgres ${var.database_name} 2> /dev/null"
    environment = {
      # for instance, postgres would need the password here:
      QSPASS     = "${var.quicksight_db_user_password}"
      PGPASSWORD = "${var.rds_cluster_password}"
    }
  }
}