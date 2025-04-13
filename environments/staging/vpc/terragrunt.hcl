locals {
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage = local.parsed.env
}

terraform {
  source = "../../../modules/vpc"
  # Use the following for specifying a specific version
  # source = "git@github.com:bfla/letterlinks-devops.git/modules/applications?ref=v2.0.0"
}

inputs = {
}

include {
  path = find_in_parent_folders()
}