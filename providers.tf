terraform {
   cloud {
    organization = "example-org-0dcec0"

    workspaces {
      name = "terraform-cloud"
    }
  }
  required_providers {

    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}