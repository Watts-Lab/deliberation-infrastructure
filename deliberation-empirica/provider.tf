
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.8"

  # Function: specifies which Terraform Cloud workspaces to use for the current working directory, only affects Terraform CLI's behavior
  # Restrictions: can only have one cloud block, can not use with state backends, cannot refer to named values
  cloud {
    organization = "css-lab-deliberation"
    workspaces {
      tags = ["deliberation"] #need to have each workspace tagged with deliberation manually
    }
  }
}


provider "aws" {
  region  = var.region # comes from variables.tf
  profile = "aws-csslab-deliberation-seas-acct-PennAccountAdministrator"
  default_tags { #tags are used for resources not directly managed by Terraform
    tags = {
      project   = "deliberation"
      app       = "deliberation-empirica"
      deployBy  = "terraform"
      workspace = terraform.workspace
      subdomain = var.subdomain
    }
  }
}