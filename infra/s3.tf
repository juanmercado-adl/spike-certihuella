resource "aws_s3_bucket" "s3_bucket_certihuella" {
  bucket = "${var.stack_id}-certihuella"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

/*
  tags = merge(
    local.common_tags,
    {
      "Name"        = "${var.stack_id}-certihuella"
      "Environment" = var.stack_id
    },
  )*/
}