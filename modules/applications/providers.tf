terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54.0, < 5.0.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.2.0, < 3.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0, < 4.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0, < 3.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0, < 4.0.0"
    }
  }

  required_version = ">= 1.0.6, < 2.0.0"
}
