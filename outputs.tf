output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.terrahouse_aws.bucket_name
}

output "S3_website_endpoint" {
  description = "s3 website static hosting website"
  value = module.terrahouse_aws.website_endpoint
}