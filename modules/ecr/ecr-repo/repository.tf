data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "this" {}

resource "aws_ecr_repository" "repo" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  # image_scanning_configuration {
  #   scan_on_push = true
  # }
}

# https://tech.scribd.com/blog/2020/orgwide-ecr.html
data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalOrgID"
      values = ["${data.aws_organizations_organization.this.id}"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
  }
}

resource "aws_ecr_repository_policy" "repository-policy" {
  repository = aws_ecr_repository.repo.name
  policy = data.aws_iam_policy_document.ecr_policy.json
}
