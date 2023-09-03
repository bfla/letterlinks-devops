provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "this" {
  bucket = var.name

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name  = var.name
    stage = var.stage
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = var.logging == true ? 1 : 0
  bucket = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.this.id
  target_prefix = "s3/${aws_s3_bucket.this.id}/"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.logging == true ? "log-delivery-write" : "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}
