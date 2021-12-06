# vector-agent
A module that installs the Vitcoria Metrics Stack on Kubernetes via Helm. Refer to the [official documentation](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack) for more information.

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
| [helm_release.victoria_metrics_stack](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.victoria_metrics_vmauth](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Default's to "true". | `bool` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `null` | no |
| <a name="input_create_vmauth_namespace"></a> [create\_vmauth\_namespace](#input\_create\_vmauth\_namespace) | Create a namespace for the deployment. Defaults to "true" | `bool` | `null` | no |
| <a name="input_create_vmstack_namespace"></a> [create\_vmstack\_namespace](#input\_create\_vmstack\_namespace) | Create a namespace for the deployment. Defaults to "true" | `bool` | `null` | no |
| <a name="input_enable_vmauth"></a> [enable\_vmauth](#input\_enable\_vmauth) | Enable VMAuth. Defaults to "true" | `bool` | `false` | no |
| <a name="input_enable_vmstack"></a> [enable\_vmstack](#input\_enable\_vmstack) | Enable VMStack. Defaults to "true" | `bool` | `true` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_vmauth_chart_name"></a> [vmauth\_chart\_name](#input\_vmauth\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_vmauth_chart_repository"></a> [vmauth\_chart\_repository](#input\_vmauth\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `null` | no |
| <a name="input_vmauth_chart_version"></a> [vmauth\_chart\_version](#input\_vmauth\_chart\_version) | The version of the Helm chart to install. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-auth for details. | `string` | `null` | no |
| <a name="input_vmauth_namespace"></a> [vmauth\_namespace](#input\_vmauth\_namespace) | The namespace used for the deployment. Defaults to "sn-system" | `string` | `null` | no |
| <a name="input_vmauth_release_name"></a> [vmauth\_release\_name](#input\_vmauth\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_vmauth_settings"></a> [vmauth\_settings](#input\_vmauth\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `{}` | no |
| <a name="input_vmauth_values"></a> [vmauth\_values](#input\_vmauth\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-auth for available options. | `list` | `[]` | no |
| <a name="input_vmstack_chart_name"></a> [vmstack\_chart\_name](#input\_vmstack\_chart\_name) | The name of the Helm chart to install. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack | `string` | `null` | no |
| <a name="input_vmstack_chart_repository"></a> [vmstack\_chart\_repository](#input\_vmstack\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `null` | no |
| <a name="input_vmstack_chart_version"></a> [vmstack\_chart\_version](#input\_vmstack\_chart\_version) | The version of the Helm chart to install. See | `string` | `null` | no |
| <a name="input_vmstack_namespace"></a> [vmstack\_namespace](#input\_vmstack\_namespace) | The namespace used for the deployment. Defaults to "sn-system" | `string` | `null` | no |
| <a name="input_vmstack_release_name"></a> [vmstack\_release\_name](#input\_vmstack\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_vmstack_settings"></a> [vmstack\_settings](#input\_vmstack\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_vmstack_values"></a> [vmstack\_values](#input\_vmstack\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack for available options. | `any` | `null` | no |

## Outputs

No outputs.
