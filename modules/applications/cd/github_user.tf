resource "aws_iam_user" "github" {
  name = var.github_username
}

# resource "aws_iam_user_policy_attachment" "github_policy_attachment" {
#   user       = var.github_username
#   policy_arn = aws_iam_user_policy.github.name
# }

resource "aws_iam_user_policy" "github" {
  name = "github-policy"
  user = aws_iam_user.github.name
policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "GithubCD",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:PutObjectTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.react_app_bucket_arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.react_app_bucket_arn}"
      ]
    },
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.react_app_cloudfront_arn}"
      ]
    },
    {
      "Action": [
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:UploadLayerPart",
        "ecr:InitiateLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Action": [
        "ecs:UpdateService"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    }
  ]
}
EOF
}
