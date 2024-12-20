# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {

  # The primary AWS region in which all resources will be created
  region = "us-east-1"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["339712909857"]

  # Assume this role for execution
  assume_role {
    session_name = "github-session"
    role_arn     = "arn:aws:iam::339712909857:role/GitHub-IaC-IAM-Provisioning"
    external_id  = "ims-infra-base"
  }
}
