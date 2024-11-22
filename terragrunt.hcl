locals {

  # Automatically load account-level variables
  account_vars  = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name         = local.account_vars.locals.account_name
  account_id           = local.account_vars.locals.aws_account_id
  region               = local.region_vars.locals.region
  environment          = local.environment_vars.locals.environment
  environment_tags     = local.environment_vars.locals.environment_tags
  execution_account_id = "977098995727"

  # Merge all tags
  common_tags = {
    BusinessAppName = "IMS",
    ManagedBy           = "Terrraform"
  }
  provider_tags = jsonencode(merge(
    local.environment_tags,
    local.common_tags))
}

generate "provider" {
  path      = "providers.tf"
  # Allow modules to override provider settings
  if_exists = "skip"
  contents = <<EOF
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
  region = "${local.region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]

  # Assume this role for execution
  assume_role {
    session_name = "github-session"
    role_arn     = "arn:aws:iam::${local.account_id}:role/GitHub-IaC-IAM-Provisioning"
    external_id  = "ims-infra-base"
  }
  default_tags {
    tags = jsondecode(<<INNEREOF
    ${local.provider_tags}
    INNEREOF
    )
  }
}
EOF
}

remote_state {
  backend = "s3"

  # Modules don't have their own S3 backend definition. Backend configuration will be generated on the fly.
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "ims-infra-base-state-${local.account_name}-${local.region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    s3_bucket_tags = {
      Project   = "IMS Infra Base"
      ManagedBy = "Terraform"
      BusinessAppName = "IMS"
    }
    dynamodb_table = "ims-infra-base-state-lock"
    dynamodb_table_tags  = {
      Project   = "IMS Infra Base"
      ManagedBy = "Terraform"
      BusinessAppName = "IMS"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
