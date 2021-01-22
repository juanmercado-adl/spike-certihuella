/*resource "aws_s3_bucket" "s3_bucket_certihuella" {
  bucket = "${var.stack_id}-certihuella"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }


  tags = merge(
    local.common_tags,
    {
      "Name"        = "${var.stack_id}-certihuella"
      "Environment" = var.stack_id
    },
  )
}*/
// creacion manual bucket s3 para lambda
//aws s3api create-bucket --bucket=mybucketjava --region=us-east-1
//aws s3 cp .\build\distributions\lambda-client-validation-1.15-SNAPSHOT.zip s3://mybucketjava/lambda-client-validation-1.15-SNAPSHOT.zip