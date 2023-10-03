terraform {
  backend "s3" {
    bucket  = "terraform-states-temp"
    encrypt = true
    key     = "AWS/DEV/terraform-states/terraform.tfstate"
    region  = "eu-central-1"
  }

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}
