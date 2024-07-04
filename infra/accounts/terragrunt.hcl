locals {
  current_dir = replace(path_relative_to_include(), "/", "-" )
  org = "asmigar"
  state_bucket_prefix = "${local.org}-${local.current_dir}"
}

generate "backend" {
  path      = "remote_backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.state_bucket_prefix}-terraform-state-${get_aws_account_id()}"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "hello-world-state-locks"
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Organisation = var.organisation
      Environment  = var.env
      Managed_By   = "Terraform"
      Project      = "hello-world-terraform"
    }
  }
}
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      version = "= 5.47.0"
      source  = "hashicorp/aws"
    }
  }
  required_version = "= 1.8.5"
}
EOF
}