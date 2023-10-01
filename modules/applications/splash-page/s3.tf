data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "splash" {
  bucket = "${var.app_domain_name}"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  tags = {
    Name = "${var.stage}-${var.service_name}"
    stage = var.stage
  }
}

resource "aws_s3_bucket_policy" "splash" {
  bucket = "${var.app_domain_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "${var.stage}-${var.service_name}-cloudfront-access",
    "Effect": "Allow",
    "Principal": {
      "Service": "cloudfront.amazonaws.com"
    },
    "Action": ["s3:GetObject"],
    "Resource": [
      "${aws_s3_bucket.splash.arn}/*"
    ],
    "Condition": {
      "StringEquals": {
        "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.splash.id}"
      }
    }
  }]
}
EOF
}

# resource "aws_s3_bucket_acl" "splash" {
#   bucket = aws_s3_bucket.splash.id
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "splash" {
  bucket = aws_s3_bucket.splash.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket_logging" "splash" {
#   bucket = aws_s3_bucket.splash.id
#   target_bucket = var.log_bucket_name
#   target_prefix = "s3/${aws_s3_bucket.splash.id}/"
# }

# resource "aws_s3_bucket" "splash-versions" {
#   bucket = "${var.app_domain_name}-versions"
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm     = "AES256"
#       }
#     }
#   }
#   tags = {
#     Name = "${var.stage}-${var.service_name}-versions"
#     stage = var.stage
#   }
# }

# resource "aws_s3_bucket_acl" "splash-versions" {
#   bucket = aws_s3_bucket.splash-versions.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_public_access_block" "splash-versions" {
#   bucket = aws_s3_bucket.splash-versions.id
#   block_public_acls   = true
#   block_public_policy = true
#   ignore_public_acls  = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_logging" "splash-versions" {
#   bucket = aws_s3_bucket.splash-versions.id
#   target_bucket = var.log_bucket_name
#   target_prefix = "s3/${aws_s3_bucket.splash-versions.id}/"
# }