# vector-agent
An opinionated module that installs the Vector Agent for Kubernetes, via Helm. See the [official documentation](https://vector.dev/docs/setup/installation/package-managers/helm/) for more info. 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.vector_agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Default's to "true". | `bool` | `null` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | The name of the Helm chart to install. | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository containing the Helm chart to install. See https://github.com/timberio/vector/tree/master/distribution/helm/vector-agent for available configuration options | `string` | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the Helm chart to install. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. | `bool` | `null` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create a namespace for the deployment. Defaults to "true". | `bool` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace used for the deployment. | `string` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release. | `string` | `null` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values. | `map(any)` | `null` | no |
| <a name="input_sink_endpoint"></a> [sink\_endpoint](#input\_sink\_endpoint) | The endpoint to which Vector will send logs. | `string` | `null` | no |
| <a name="input_sink_name"></a> [sink\_name](#input\_sink\_name) | The name of the vector sink. | `string` | `null` | no |
| <a name="input_sink_oauth_audience"></a> [sink\_oauth\_audience](#input\_sink\_oauth\_audience) | The OAuth audience for the sink authorization config. | `string` | `null` | no |
| <a name="input_sink_oauth_credentials_url"></a> [sink\_oauth\_credentials\_url](#input\_sink\_oauth\_credentials\_url) | A base64 encoded string containing the OAuth credentials URL for the sink authorization config. | `string` | `null` | no |
| <a name="input_sink_oauth_issuer_url"></a> [sink\_oauth\_issuer\_url](#input\_sink\_oauth\_issuer\_url) | The OAuth issuer URL for the sink authorization config. | `string` | `null` | no |
| <a name="input_sink_topic"></a> [sink\_topic](#input\_sink\_topic) | The topic for the sink to which Vector will send logs. | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation. | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |

## Outputs

No outputs.
