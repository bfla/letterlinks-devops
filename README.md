# Devops

## Getting started with Terragrunt/Terraform
### Dependencies & Prerequisites

### Terraform and Terragrunt Installation
```bash
# Mac
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

brew install terragrunt
```

#### AWS access
To deploy, you'll also need an AWS key with Admin permissions for the AWS Account in which Terraform will run.  

> [FOR NOW] CREATE SOME ACCESS CREDENTIALS AND JUST EXPORT THEM AS ENVIRONMENT VARIABLES

```bash
export AWS_ACCESS_KEY_ID="<access_key>"
export AWS_SECRET_ACCESS_KEY="<secret_key>"
export AWS_DEFAULT_REGION="us-east-1"
```

## Workflow

### Quick start

#### Overall Architecture

##### Terraform Modules
There are N Terraform modules under the `modules/` folder.  These modules are meant to be fairly generic, allowing for most values to be overridden by inputs specified in `environemnts/<environment>/<module>/[<instance>]/terragrunt.hcl`.
> Sometimes there will be only one instance of a module (like applications), other times there will be many (like s3 buckets)

###### Examples:
- `modules/s3`: Generic module that creates an S3 Bucket
- `modules/ecr`: This module creates the ecr repos
- `modules/applications`: This module creates everything related to the applications


#### Running Terragrunt
You call terragrunt the same way you'd call terraform, just replace `terraform` with `terragrunt`.
```bash
cd environments/<environment>/<module>
terragrunt init
terragrunt plan
terragrunt apply
```
