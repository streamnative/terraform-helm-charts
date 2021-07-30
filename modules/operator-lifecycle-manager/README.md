# operator-lifecycle-manager
This module installs the operator lifecycle management framework using a somewhat "unnofficial" Helm chart published by [Operator Framework](https://github.com/operator-framework). For stability purposes, we will keep the chart local to this module while we wait for it to be released in an official Helm repository. 

The most recent version can be found in the `operator-framework/operator-lifecycle-manager` repo in github, [linked here](https://github.com/operator-framework/operator-lifecycle-manager/tree/master/deploy/chart).

## Notable Changes
If updating the charts, please note to omit the file `0000_50_olm_00-namespace.yaml`, as Helm should not really be used for managing namespaces.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.operator_lifecycle_manager](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubernetes_namespace.olm](https://registry.terraform.io/providers/hashicorp/kubernetes/2.2.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.operators](https://registry.terraform.io/providers/hashicorp/kubernetes/2.2.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Default's to "true". | `bool` | `true` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository containing the Helm chart to install. Defaults to the chart local to this module. | `string` | `""` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_olm_namespace"></a> [olm\_namespace](#input\_olm\_namespace) | The namespace used by OLM and its resources | `string` | `"olm"` | no |
| <a name="input_olm_operators_namespace"></a> [olm\_operators\_namespace](#input\_olm\_operators\_namespace) | The namespace where OLM will install the operators | `string` | `"operators"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release | `string` | `"operator-lifecycle-manager"` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |

## Outputs

No outputs.

