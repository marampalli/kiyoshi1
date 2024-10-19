terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
  backend "s3" {
    bucket = "kiyoshi-terraform-state"
    key    = "dev/jenkins-k8s.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  # Configuration options
  # profile = "default"
}