locals {
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage = local.parsed.env
}

terraform {
  source = "../../../modules/management"
  # Use the following for specifying a specific version
  # source = "git@github.com:bfla/letterlinks-devops.git/modules/applications?ref=v2.0.0"
}

inputs = {
  staging_account_id = "986906465263"
}

include {
  path = find_in_parent_folders()
}