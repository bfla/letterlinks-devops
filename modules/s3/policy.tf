data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "logs" {
  count = var.logging == true ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.this.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.this.arn}/${var.cloudtrail_log_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::127311923021:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.name}/eks-alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        },
        {
          "Effect": "Allow",
          "Principal": {
              "Service": "lambda.amazonaws.com"
          },
          "Action": [
              "s3:PutObject",
              "s3:GetObject"
          ],
          "Resource": "${aws_s3_bucket.this.arn}/canaries/*",
          "Condition": {
              "StringEquals": {
                  "AWS:SourceAccount": "${data.aws_caller_identity.current.account_id}"
              }
          }
      },
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "lambda.amazonaws.com"
          },
          "Action": "s3:GetBucketLocation",
          "Resource": "${aws_s3_bucket.this.arn}",
          "Condition": {
              "StringEquals": {
                  "AWS:SourceAccount": "${data.aws_caller_identity.current.account_id}"
              }
          }
      }
    ]
}
POLICY
}
