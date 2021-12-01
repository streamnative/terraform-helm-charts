# operator-lifecycle-manager
This module installs the operator lifecycle management framework using a somewhat "unnofficial" Helm chart published by [Operator Framework](https://github.com/operator-framework). For stability purposes, we will keep the chart local to this module while we wait for it to be released in an official Helm repository. 

The most recent version can be found in the `operator-framework/operator-lifecycle-manager` repo in github, [linked here](https://github.com/operator-framework/operator-lifecycle-manager/tree/master/deploy/chart).

## Notable Changes
If updating the charts, please note to omit the file `0000_50_olm_00-namespace.yaml`. We let the helm provider manage this directly rather than using a templated CR.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.operator_lifecycle_manager](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubernetes_namespace.olm_install](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. | `bool` | `null` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | The name of the chart to install. | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository containing the Helm chart to install. Defaults to the chart local to this module. | `string` | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the chart to install. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `null` | no |
| <a name="input_create_install_namespace"></a> [create\_install\_namespace](#input\_create\_install\_namespace) | Create a namespace for the deployment. | `bool` | `null` | no |
| <a name="input_create_olm_namespace"></a> [create\_olm\_namespace](#input\_create\_olm\_namespace) | Whether or not to create the namespace used for OLM and its resources. | `bool` | `null` | no |
| <a name="input_install_namespace"></a> [install\_namespace](#input\_install\_namespace) | The namespace where OLM will install the operators. | `string` | `null` | no |
| <a name="input_olm_namespace"></a> [olm\_namespace](#input\_olm\_namespace) | The namespace used by OLM and its resources | `string` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |

## Outputs

No outputs.
