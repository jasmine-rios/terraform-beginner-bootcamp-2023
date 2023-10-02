# terraform {
#    cloud {
#     organization = "example-org-0dcec0"

#     workspaces {
#       name = "terra-house-hello-kitty-island-adventure"
#     }
#   }
#
# }

module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
}