resource "aws_ssoadmin_permission_set" "local-dev" {
  name             = "LocalDeveloperPermissions"
  description      = "Permission set for local development environment"
  instance_arn     = local.sso_arn
  session_duration = "PT12H"
}

resource "aws_identitystore_group" "local-dev" {
  identity_store_id = local.identity_store_id
  display_name      = "LocalDeveloper"
  description       = "Local Developer group"
}

data "aws_iam_policy_document" "local-dev" {
  statement {
    sid = "LocalDeveloperPolicy"

    # Local developers can access specific S3 buckets
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::mem-staging-private-data/*",
      "arn:aws:s3:::mem-staging-private-data"
      # "arn:aws:s3:::mem-staging-export-data/*",
      # "arn:aws:s3:::mem-staging-export-data",
      # "arn:aws:s3:::mem-staging-public-media/*",
      # "arn:aws:s3:::mem-staging-public-media"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "local-dev" {
  inline_policy      = data.aws_iam_policy_document.local-dev.json
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.local-dev.arn
  depends_on = [aws_ssoadmin_account_assignment.local-dev]
}

resource "aws_ssoadmin_account_assignment" "local-dev" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.local-dev.arn

  principal_id   = aws_identitystore_group.local-dev.group_id
  principal_type = "GROUP"

  target_id   = local.staging_account_id
  target_type = "AWS_ACCOUNT"
}