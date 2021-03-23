resource "aws_s3_bucket_policy" "asset_bucket" {
  bucket = var.s3_bucket_asset_bucket_id

  policy = <<POLICY
{
   "Version":"2021-03-23",
   "Statement":[
      {
         "Sid":"OnlyCloudfrontReadAccess",
         "Effect":"Allow",
         "Principal":{
            "AWS":"${aws_cloudfront_origin_access_identity.default.iam_arn}"
         },
         "Action":"s3:GetObject",
         "Resource":"${var.s3_bucket_asset_bucket_arn}/*"
      }
   ]
}
POLICY
}