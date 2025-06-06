locals {
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage = local.parsed.env
}

terraform {
  source = "../../../modules/ecr"
  # Use the following for specifying a specific version
  # source = "git@github.com:bfla/letterlinks-devops.git/modules/ecr?ref=v2.0.0"
}

inputs = {
  stage = "${local.stage}"
}

include {
  path = find_in_parent_folders()
}
