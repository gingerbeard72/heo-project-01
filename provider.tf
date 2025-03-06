terraform {
  backend "http" {
    address        = ""
    lock_address   = ""
    unlock_address = ""
  }

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
  }
}

provider "aws" {
  alias   = ""
  region  = ""
  profile = ""
}
