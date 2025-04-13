resource "aws_ssoadmin_permission_set" "admin" {
  name             = "AdminAccess"
  description      = "Permission set for admin access"
  instance_arn     = local.sso_arn
  session_duration = "PT1H"
}

resource "aws_identitystore_group" "admin" {
  identity_store_id = local.identity_store_id
  display_name      = "Admin"
  description       = "Admin group"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = local.sso_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

resource "aws_ssoadmin_account_assignment" "staging-admin" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admin.group_id
  principal_type = "GROUP"

  target_id   = local.staging_account_id
  target_type = "AWS_ACCOUNT"
}

# resource "aws_ssoadmin_account_assignment" "prod-admin" {
#   instance_arn       = local.sso_arn
#   permission_set_arn = aws_ssoadmin_permission_set.admin.arn

#   principal_id   = aws_identitystore_group.admin.group_id
#   principal_type = "GROUP"

#   target_id   = local.prod_account_id
#   target_type = "AWS_ACCOUNT"
# }