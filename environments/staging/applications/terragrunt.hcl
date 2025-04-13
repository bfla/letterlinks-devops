locals {
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage = local.parsed.env
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "../../../modules/applications"
  # Use the following for specifying a specific version
  # source = "git@github.com:bfla/letterlinks-devops.git/modules/applications?ref=v2.0.0"
}

inputs = {
  stage                         = "${local.stage}"
  image_tag                     = local.stage == "prod" ? "latest" : "staging"
  ecs_cluster_name              = "${local.stage}"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  sld                           = "mindsemerge"
  tld                           = "com"
  rds_instance_type             = "db.t3.medium"
  app_memory                    = 512 # 0.5 GB
  app_cpu                       = 256 # 0.25 vCPU
  keypair_name                  = "${local.stage}-mem-bastion"
  trusted_ip_addresses          = [
    "64.85.163.226/32", // Brian Bamboo coworking space
    "68.36.51.62/32", // Brian townhouse
    "97.95.101.170/32" // Brian Cabin
  ]
  gmail_mx_val                  = "dbarbemacvyrnm7gjir62sh7dnltviguslr7vqgfv7t3uagghgoq.mx-verification.google.com."
}

include {
  path = find_in_parent_folders()
}
