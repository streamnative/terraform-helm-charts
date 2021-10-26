# Istio Operator
This is an opinionated module for installing and configuring Istio, along with the Kiali console, for StreamNative Cloud.

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
| [helm_release.istio_operator](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.kiali_operator](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Default's to "true". | `bool` | `true` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the kubernetes cluster where Istio is being configured. | `string` | n/a | yes |
| <a name="input_enable_istio_operator"></a> [enable\_istio\_operator](#input\_enable\_istio\_operator) | Enables the Istio Operator for installation. Can be disabled if you only need to install Kiali. | `bool` | `true` | no |
| <a name="input_enable_kiali_operator"></a> [enable\_kiali\_operator](#input\_enable\_kiali\_operator) | Enables the Kiali Operator for installation. Can be disabled if you only need to install Istio. | `bool` | `true` | no |
| <a name="input_istio_chart_name"></a> [istio\_chart\_name](#input\_istio\_chart\_name) | The name of the Helm chart to install | `string` | `"istio-operator"` | no |
| <a name="input_istio_chart_repository"></a> [istio\_chart\_repository](#input\_istio\_chart\_repository) | The repository containing the Helm chart to install | `string` | `"https://stevehipwell.github.io/helm-charts/"` | no |
| <a name="input_istio_chart_version"></a> [istio\_chart\_version](#input\_istio\_chart\_version) | The version of the Helm chart to install. See https://github.com/stevehipwell/helm-charts/tree/master/charts/istio-operator for available versions. | `string` | `"2.3.4"` | no |
| <a name="input_istio_namespace"></a> [istio\_namespace](#input\_istio\_namespace) | The namespace used for the Istio operator. | `string` | n/a | yes |
| <a name="input_istio_release_name"></a> [istio\_release\_name](#input\_istio\_release\_name) | The name of the Istio release | `string` | `"istio-operator"` | no |
| <a name="input_istio_settings"></a> [istio\_settings](#input\_istio\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `{}` | no |
| <a name="input_kiali_chart_name"></a> [kiali\_chart\_name](#input\_kiali\_chart\_name) | The name of the Helm chart to install | `string` | `"kiali-operator"` | no |
| <a name="input_kiali_chart_repository"></a> [kiali\_chart\_repository](#input\_kiali\_chart\_repository) | The repository containing the Helm chart to install | `string` | `"https://kiali.org/helm-charts"` | no |
| <a name="input_kiali_chart_version"></a> [kiali\_chart\_version](#input\_kiali\_chart\_version) | The version of the Helm chart to install. See https://github.com/kiali/helm-charts/tree/v1.42/kiali-operator for configuration options, and note that newer versions will be in their corresponding branch in the git repo. | `string` | `"1.42.0"` | no |
| <a name="input_kiali_namespace"></a> [kiali\_namespace](#input\_kiali\_namespace) | The namespace used for the Kiali operator. | `string` | n/a | yes |
| <a name="input_kiali_release_name"></a> [kiali\_release\_name](#input\_kiali\_release\_name) | The name of the Kiali release | `string` | `"kiali-operator"` | no |
| <a name="input_kiali_settings"></a> [kiali\_settings](#input\_kiali\_settings) | Additional settings which will be passed to the Helm chart values. See https://github.com/kiali/helm-charts/blob/v1.42/kiali-operator/values.yaml for available options | `map(any)` | `{}` | no |
| <a name="input_mesh_id"></a> [mesh\_id](#input\_mesh\_id) | The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments | `string` | n/a | yes |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release | `string` | `"istio-operator"` | no |
| <a name="input_revision_tag"></a> [revision\_tag](#input\_revision\_tag) | The revision tag value use for the Istio label "istio.io/rev". | `string` | `"sn-stable"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |
| <a name="input_trust_domain"></a> [trust\_domain](#input\_trust\_domain) | The trust domain used by Istio, which corresponds to the the trust root of a system | `string` | n/a | yes |

## Outputs

No outputs.
