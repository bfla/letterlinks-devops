locals {
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage = local.parsed.env
}

terraform {
  source = "../../../modules/secrets-manager"
  # Use the following for specifying a specific version
  # source = "git@github.com:bfla/letterlinks-devops.git/modules/secrets-manager?ref=v2.0.0"
}

inputs = {
  stage = "${local.stage}"
  name = "${local.stage}-terraform"
  description = "Secret for storing secrets used by terraform"
  # WARNING: DO NOT run this module again unless you want to delete the current secrets.
  # Doing so will BREAK the existing app. This is intended to be run ONLY ONCE
  # for each cloud environment.
  kv_pairs = {
    jwt_secret = ""
    rds_password = ""
    rds_username = ""
    mongo_url = ""
    elevenlabs_api_key = ""
    slack_hook = ""
    email_host_password = ""
  }
}

include {
  path = find_in_parent_folders()
}