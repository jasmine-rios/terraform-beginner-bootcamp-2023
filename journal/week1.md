# Terraform Beginner Bootcamp 2023 - Week1

## Fix tags 

Locally delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag
```sh
git push --delete origin <tagname>
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.m.P
git push --tags
git checkout main

```
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

## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare these terrform variables in its own variables.tf

```go
modules "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
}
```

### Module Sources

Using the source we can import the module from various sources e.g.
- locally
- GitHub
- Terraform Registry

```go
modules "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
}
```
(https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs (Large Language Models) such as ChatGPT may not be trained about documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### Fileexists function

This is a built-in terraform function that checks the exists of a file.
We used it in our variables.tf nested
```go
 validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified file path for error.html does not exist."
  }
```
[Fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

This is a built in function as well that makes a hash when you give it a path. We used it in helping to create a unique eTag each time we change data in that file we provided the path for.

[Filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variables

In terraform there is a special variable in path that allows us to specify local paths.
- path.module = get the path for the current module
-path.root = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html
  etag = filemd5(var.index_html_filepath)
}

## Terraform Locals

Locals allow us to define local variables.
It can be very useful when we need to transform data into another format and have a refrenced variable.
```go
locals {
  s3_origin_id = "myS3Origin"
}
```

[Locals Values](https://developer.hashicorp.com/terraform/language/values/locals)
## Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when want to reference cloud resources without inputting them. e.g.

```go
data "aws_caller_identity" "current" {}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```go
jsonencode({"hello"="world"})
{"hello":"world"}
```

[Jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Agruements Lifecycle ](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

e.g. 
```go
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
```
[Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allow you to execute commands on compute instances e.g. a AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists. 

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine running the terraform commands eg. plan and apply

```go
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```
[Local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
### Remote-exec

This will execute commands on a machine which you targer. You will need to provide credentials such as ssh to get into the machine

```go
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
[Remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)