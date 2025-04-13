locals {
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage = local.parsed.env
}

terraform {
  source = "../../../modules/ecs-cluster"
  # Use the following for specifying a specific version
  # source = "git@github.com:bfla/letterlinks-devops.git/modules/ecs?ref=v2.0.0"
}

inputs = {
  cluster_name = "${local.stage}"
  image_tag = local.stage == "prod" ? "latest" : "staging"
}

include {
  path = find_in_parent_folders()
}
