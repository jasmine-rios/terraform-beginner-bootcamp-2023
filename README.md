# Terraform Beginner Bootcamp 2023

## Semantic Versioning

This project is going utilize semantic versioning for its tagging.

[Semantic Versioning](https://semver.org)

The general format:

**MAJOR.MINOR.PATCH**, eg. '1.0.1'

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes

The Terraform CLI instructions have changed due to gpg keyring changes. So we needed to refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 

### Considerations for Linux Distribution

This project is build against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we noticed that the bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allows us an easier to debug and execute manually Terraform CLI install
- This will allow better portablity for other projects that need to install Terraform CLI

#### Shebang Considerations

A Shebang (prounced Sha-bang) tells the bash script what program that will interpret the script. eg. `#!/bin/bash`

ChatGPT recommends this format for bash: `#!/usr/bin/env bash`

- For portabillity for different OS distributions 
- Will search the user's PATH fpr the bash executable

[Shebang for Unix](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`
#### Linux Permisions Considerations

In order to make our bash scripts executable we need to change linux permission to fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:
```sh
chmod 744 ./bin/install_terraform_cli
```

[How to Use chmod to Change Permissions](https://en.wikipedia.org/wiki/Chmod)

### GitHub Lifecyle (Before, Init, Commmand)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

[Gitpod Tasks Process](https://www.gitpod.io/docs/configure/workspaces/tasks#tasks)

### Working with Env Vars

We can list out all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export. eg.
```sh
#!/usr/bin/env bash 

HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

#### Scoping for Env Vars

When you open up new bash terminals in VSCode, it will not be aware of env vars you set in another window

If you want Env Vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile. eg. `bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into Gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars

### AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:`
```sh
aws sts get-caller-identity
```

If it is successful you should a json payload return that looks like this
```json
{
    "UserId": "AIAA75AN7YUW56Y6DGWY5",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform_beginner_bootcamp"
}
```
We'll need to generate AWS CLI credits from IAM user in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the terraform registry which is located at [registry.terraform.io](https://registry.terraform.io)

- **Providers** is an interface to APIs that will allow you to create resources in terraform.

- **Modules** are a way to refactor or to make large amounts of terraform modular, portable, and sharable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/)
### Terraform Console

We can see a list of all the terraform commands by simply typing `terraform`.


#### Terrafrom init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers we will use in this project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan to be passed to an apply, but often you can ignore the outputing

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

##### Problems Applying S3 Bucket

When applying bucket with main.tf, we needed to make sure that the parameters for resource "aws_s3_bucket" "bucket name" had upper as false and lower as true

If you don't have these set then the terraform plan will try to name bucket with uppercase which is not allowed for an S3 bucket. `terraform plan` will say it's good but when using `terraform apply`, it will fail with invalid bucket name

[S3 Bucket Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)
#### Terraform Destroy

`terraform destroy`
This will destroy resources.

You can also use the auto-approve flag to skip the approve prompt eg. `terraform destroy --auto-approve`
#### Terraform Lock files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be commited** to your Version Control System (VCS) eg. GitHub

#### Terraform State files

`terraform.tfstate` contains information about the current state of your infrastructure. 

This file **should not be committed** to your VCS.

This file can contain senstitive data.

If you loose this file you loose knowing the state of the infrastructure.

`terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash a wiswig view to generate a token.
However, it does not work as expected in Gitpod VSCode in the browser. It works in Gitpod VSCode locally.

The workaround if you are using the Gitpod VSCode in the browser is to manually generate a token in Terraform Cloud.

```
https://app.terraform.io/app/settings/tokens
```

Then create the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace the token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD TOKEN"
    },
  }
}
```

We have automated this workaround process using the following bash script [./bin/generate_tfrc_credentials](./bin/generate_tfrc_credentials)

## Add your AWS credentials to Terraform Cloud

You have to go to your project in Terraform Cloud and add your AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, and AWS_ACCESS_KEY_ID to your environment variables.

If you don't you will run into an error running a Terraform plan saying it doesn't have the credentials.

**MAKE SURE WS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID IS MARKED AS SENSTIVE!!**
