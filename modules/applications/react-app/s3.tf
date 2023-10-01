data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "react-app" {
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

resource "aws_s3_bucket_policy" "react-app" {
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
      "${aws_s3_bucket.react-app.arn}/*"
    ],
    "Condition": {
      "StringEquals": {
        "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.react-app.id}"
      }
    }
  }]
}
EOF
}

# resource "aws_s3_bucket_acl" "react-app" {
#   bucket = aws_s3_bucket.react-app.id
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "react-app" {
  bucket = aws_s3_bucket.react-app.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket_logging" "react-app" {
#   bucket = aws_s3_bucket.react-app.id
#   target_bucket = var.log_bucket_name
#   target_prefix = "s3/${aws_s3_bucket.react-app.id}/"
# }

resource "aws_s3_bucket" "react-app-versions" {
  bucket = "${var.app_domain_name}-versions"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  tags = {
    Name = "${var.stage}-${var.service_name}-versions"
    stage = var.stage
  }
}

# resource "aws_s3_bucket_acl" "react-app-versions" {
#   bucket = aws_s3_bucket.react-app-versions.id
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "react-app-versions" {
  bucket = aws_s3_bucket.react-app-versions.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket_logging" "react-app-versions" {
#   bucket = aws_s3_bucket.react-app-versions.id
#   target_bucket = var.log_bucket_name
#   target_prefix = "s3/${aws_s3_bucket.react-app-versions.id}/"
# }