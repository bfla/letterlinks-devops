data "aws_ssoadmin_instances" "this" {}

locals {
  sso_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  staging_account_id = var.staging_account_id
}