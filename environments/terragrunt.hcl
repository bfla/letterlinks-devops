locals {
  # Parse the file path we're in to read the env name: e.g., env
  # will be "dev" in the dev folder, "stage" in the stage folder,
  # etc.
  parsed = regex(".*/environments/(?P<env>.*?)/.*", get_terragrunt_dir())
  stage  = local.parsed.env
  region = "us-east-1"
}

remote_state {
  backend = "s3"

  config = {
    bucket = "letterlinks-${local.stage}-tfstate"
    region = "${local.region}"
    key    = "${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
