<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_role_with_inline_policy"></a> [role\_with\_inline\_policy](#module\_role\_with\_inline\_policy) | tfregistry.xpanse.com/xpanse-tf-reg__shared/iam-role-with-inline-policy/aws | v2.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The account ID belonging to the account where resources will be provisioned. | `string` | n/a | yes |
| <a name="input_execution_account_id"></a> [execution\_account\_id](#input\_execution\_account\_id) | The account ID of the execution account used to orchestrate resource provisioning and store state for environment-specific accounts. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where resources will be provisioned. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->