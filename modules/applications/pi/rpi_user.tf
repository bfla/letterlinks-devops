resource "aws_iam_user" "pi" {
  name = var.pi_username
}

# resource "aws_iam_user_policy_attachment" "github_policy_attachment" {
#   user       = var.github_username
#   policy_arn = aws_iam_user_policy.github.name
# }

resource "aws_iam_user_policy" "github" {
  name = "pi-policy"
  user = aws_iam_user.pi.name
policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "RaspberryPiCD",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ecr:us-east-1:*:/repository/rpi"
      ]
    }
  ]
}
EOF
}
