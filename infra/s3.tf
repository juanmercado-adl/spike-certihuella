resource "aws_s3_bucket" "s3_bucket_certihuella" {
  bucket = "${var.bucket_name}-certihuella"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }


  /*tags = merge(
    local.common_tags,
    {
      "Name"        = "${var.stack_id}-certihuella"
      "Environment" = var.stack_id
    },
  )*/
}

resource "aws_s3_bucket_object" "files" {
 bucket = aws_s3_bucket.s3_bucket_certihuella.id
 key    = "files/"
}

resource "aws_s3_bucket_notification" "s3_bucket_certihuella_in_notification" {
 bucket = aws_s3_bucket.s3_bucket_certihuella.id
 
 lambda_function {
   lambda_function_arn = aws_lambda_function.lambda_process_file.arn
   events              = ["s3:ObjectCreated:*"]
   filter_prefix       = "files/"
 }
 depends_on = [aws_lambda_permission.allow_bucket]
}
