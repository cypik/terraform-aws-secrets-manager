# terraform-aws-secrets-manager

# Terraform AWS Cloud secrets-manager Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#Author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform module creates an AWS secrets-manager along with additional configuration options.
## Usage
To use this module, you should have Terraform installed and configured for AWS. This module provides the necessary Terraform configuration for creating AWS resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples:

```hcl
## Binary:
module "secrets_manager" {
  source      = "../../"
  name        = local.name
  environment = local.environment

  secrets = [
    {
      name          = "secret-binary-1"
      description   = "This is a binary secret"
      secret_binary = "ssh-rsa /+ZHJ4gx0gB8yQ/JWPhG1Xi2AWrM test-ssh-key"
    },
    {
      name                    = "secret-binary-2"
      description             = "Another binary secret"
      secret_binary           = "ssh-rsa /+ZHJ4gx0gB8yQ/oJ test-ssh-key-2"
      recovery_window_in_days = 7
    }
  ]
}
```

```hcl
## Complete:
module "secrets_manager" {
  source      = "../../"
  name        = local.name
  environment = local.environment
  secrets = [
    {
      name                    = "secret-11"
      description             = "My secret 1"
      recovery_window_in_days = 7
      secret_string           = "This is an example"
    },
    {
      name                    = "secret-12"
      description             = "My secret 2"
      recovery_window_in_days = 7
      secret_string           = "This is another example"
    }
  ]
}
```

```hcl
## key-value:
module "secrets_manager" {
  source      = "../../"
  name        = local.name
  environment = local.environment
  secrets = [
    {
      name        = "secret-kv-1"
      description = "This is a key/value secret"
      secret_key_value = {
        key1  = "value1"
        key2  = "value2"
        key3  = "value2"
        key4  = "value2"
        key5  = "value2"
        key6  = "value2"
        key7  = "value2"
        key8  = "value2"
        key89 = "value2"

      }
      recovery_window_in_days = 7
    },
    {
      name        = "secret-kv-2"
      description = "Another key/value secret"
      secret_key_value = {
        username = "user"
        password = "topsecret"
      }
      recovery_window_in_days = 7
    },
  ]
}
```
This example demonstrates how to create various AWS resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-aws-secrets-manager/tree/master/examples) directory within this repository.

## License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/cypik/terraform-aws-secrets-manager/blob/master/LICENSE) file for more details.

## Author
Your Name
Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.99.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.99.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/aws | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.sm-sv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.sm-svu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| <a name="input_enable_rotation"></a> [enable\_rotation](#input\_enable\_rotation) | Determines whether secret rotation is enabled | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to control the vpc creation. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com' | `string` | `"info@cypik.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `30` | no |
| <a name="input_replica"></a> [replica](#input\_replica) | Configuration block to support secret replication | `map(any)` | `{}` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-aws-secrets-manager"` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | Specifies the ARN of the Lambda function that can rotate the secret | `string` | `""` | no |
| <a name="input_rotation_rules"></a> [rotation\_rules](#input\_rotation\_rules) | A structure that defines the rotation configuration for this secret | `map(any)` | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secrets to keep in AWS Secrets Manager | `any` | `[]` | no |
| <a name="input_unmanaged"></a> [unmanaged](#input\_unmanaged) | Terraform must ignore secrets lifecycle. Using this option you can initialize the secrets and rotate them outside Terraform, thus, avoiding other users to change or rotate the secrets by subsequent runs of Terraform | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Secret arn list |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | Secret id list |
| <a name="output_version_id"></a> [version\_id](#output\_version\_id) | The unique identifier of the version of the secret. |
<!-- END_TF_DOCS -->