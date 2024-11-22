variable "account_id" {
  description = "The account ID belonging to the account where resources will be provisioned."
  type        = string
}

variable "region" {
  description = "The region where resources will be provisioned."
  type        = string
}

variable "execution_account_id" {
  description = "The account ID of the execution account used to orchestrate resource provisioning and store state for environment-specific accounts."
  type        = string
}
