resource "aws_ssoadmin_permission_set" "read-access" {
  name             = "ViewOnlyAccess"
  description      = "Permission set for admin access"
  instance_arn     = local.sso_arn
  session_duration = "PT1H"
}

resource "aws_identitystore_group" "read-access" {
  identity_store_id = local.identity_store_id
  display_name      = "ViewOnlyAccess"
  description       = "Read-only group"
}

resource "aws_ssoadmin_managed_policy_attachment" "read-access" {
  instance_arn       = local.sso_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ViewOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.read-access.arn
}

resource "aws_ssoadmin_account_assignment" "staging-read-access" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.read-access.arn

  principal_id   = aws_identitystore_group.read-access.group_id
  principal_type = "GROUP"

  target_id   = local.staging_account_id
  target_type = "AWS_ACCOUNT"
}

# resource "aws_ssoadmin_account_assignment" "prod-read-access" {
#   instance_arn       = local.sso_arn
#   permission_set_arn = aws_ssoadmin_permission_set.read-access.arn

#   principal_id   = aws_identitystore_group.read-access.group_id
#   principal_type = "GROUP"

#   target_id   = local.prod_account_id
#   target_type = "AWS_ACCOUNT"
# }