terraform {
  required_providers {

    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

#https://developer.hashicorp.com/terraform/language/data-sources
data "aws_caller_identity" "current" {}