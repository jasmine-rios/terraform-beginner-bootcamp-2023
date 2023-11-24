terraform {
    required_providers {
      terratowns = {
        source = "local.providers/local/terratowns"
        version = "1.0.0"
      }
    }
   cloud {
    organization = "example-org-0dcec0"

    workspaces {
      name = "terra-house-hello-kitty-island-adventure"
    }
  }

}


provider "terratowns" {
    endpoint = var.terratowns_endpoint
    user_uuid = var.teacherseat_user_uuid
    token = var.terratowns_access_token
}
module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.teacherseat_user_uuid
    error_html_filepath = var.error_html_filepath
    index_html_filepath = var.index_html_filepath
    content_version = var.content_version
    assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Hello Kitty Island Adventure!"
  description = <<DESCRIPTION
Hello Kitty Island Adventure is a social game where you try to make the best island and make friends with the Sanrio crew. This guide will introduce you to the characters and the world in which the game exists.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  #domain_name = "3fdfa3.cloudfront.net"
  town = "missingo"
  content_version = 4
}