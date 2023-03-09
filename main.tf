terraform {
  cloud {
    organization = "kavishree-org"
    workspaces {
      name = "kiyoshi1"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}