provider "aws" {
  region      = var.region
}

module "sso" {
  source = "./sso"
  staging_account_id = var.staging_account_id
  # prod_account_id = var.prod_account_id
}

# module "account-settings" {
#   source = "./account-settings"
# }