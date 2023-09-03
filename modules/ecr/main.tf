provider "aws" {
  region = var.region
}

module "repo" {
  count = length(var.repos)
  source = "./ecr-repo"
  name = var.repos[count.index]
}
