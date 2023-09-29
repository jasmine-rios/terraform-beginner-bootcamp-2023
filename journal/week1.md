# Terraform Beginner Bootcamp 2023 - Week1
## Root Module Structure

Our root module structure is as follows:
```ascii
PROJECT_ROOT
    |
    |--- main.tf - everything else
    |
    |--- variable.tf - stores the structure of input variables
    |
    |--- variables.tf - stores the structure of input variables
    |
    |--- terraform.tfvars - the data of variables we want to load into our terraform project
    |
    |--- providers.tf - defined required providers and their configuration
    |
    |--- outputs.tf - stores our outputs
    |
    |--- README.md - required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables
### Terraform Cloud Variables

In terraform we can set two kinds of variables:
- Environment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensentive so they are not visibily in the UI. 

### Loading Terraform Input Variables

[Terraform INput Variables](https://developer.hashicorp.com/terraform/language/values/variables)
### Var Flag

We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uuid="my user_id"`

### Var-file Flag

TODO:

### terraform.tvfars

Instead of running the var flag, you can add variable to terraform.tfvars to make the variable specified and you should only have to run `terraform plan` without having to specify the `-var` flag.

### Order of Terraform Variables

TODO: document which terraform variables take precedence

## Dealing with Configuration Drift

## What happens if we lose our state file?

If you lose your statefile, you most likely have to tear down all your cloud infrastructure manually. 

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.website_bucket`

[Terraform Import](https://developer.hashicorp.com/terraform/language/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)
### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually through ClickOps.

If we run Terraform plan with attempt to put our infrastructure back into the expected state fixing Configuration Drift