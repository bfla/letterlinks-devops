data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "private" {
  bucket = "${var.private_data_bucket_name}"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  tags = {
    Name = var.private_data_bucket_name
    stage = var.stage
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.private.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# FIXME
# resource "aws_s3_bucket_acl" "private" {
#   bucket = aws_s3_bucket.private.id
#   acl    = var.logging == true ? "log-delivery-write" : "private"
# }

# resource "aws_s3_bucket_logging" "private" {
#   count = var.logging == true ? 1 : 0
#   bucket = aws_s3_bucket.this.id
#   target_bucket = aws_s3_bucket.this.id
#   target_prefix = "s3/${aws_s3_bucket.this.id}/"
# }