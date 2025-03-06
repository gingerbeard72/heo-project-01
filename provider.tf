terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/54874206/terraform/state/prod"
    lock_address   = "https://gitlab.com/api/v4/projects/54874206/terraform/state/prod/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/54874206/terraform/state/prod/lock"
  }

  # backend "local" {
  #   path = "terraform.tfstate"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
  }
}

provider "aws" {
  alias   = "prod"
  region  = "ap-southeast-2"
  profile = "prod"
}
