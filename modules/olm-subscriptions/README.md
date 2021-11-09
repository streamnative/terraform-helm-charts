# OLM Subscription Module	
This module creates the OLM subscriptions necessary to manage the StreamNative, et al, Operators

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.olm_subscriptions](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Default's to "true". | `bool` | `true` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_install_namespace"></a> [install\_namespace](#input\_install\_namespace) | The namespace used for installing the operators managed by OLM | `string` | `"sn-system"` | no |
| <a name="input_olm_namespace"></a> [olm\_namespace](#input\_olm\_namespace) | The namespace used by OLM and its resources | `string` | `"olm"` | no |
| <a name="input_registry"></a> [registry](#input\_registry) | The registry containing StreamNative's operator catalog images | `string` | n/a | yes |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release | `string` | `"olm-subscriptions"` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `300` | no |

## Outputs

No outputs.

