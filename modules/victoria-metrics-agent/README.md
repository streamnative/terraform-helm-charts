<!--
  ~ Copyright 2023 StreamNative, Inc.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~     http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

# vitctoria-metrics-agent
An opinionated module that installs the Victoria Metrics Agent (VMAgent) on Kubernetes via Helm. Refer to the [official documentation](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-agent) for more information.

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
| [helm_release.vmagent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. | `bool` | `null` | no |
| <a name="input_basicauth_enabled"></a> [basicauth\_enabled](#input\_basicauth\_enabled) | Enable basic auth for remote write endpoint. Requires providing a username and base64 encoded password. | `bool` | `null` | no |
| <a name="input_basicauth_password"></a> [basicauth\_password](#input\_basicauth\_password) | If basic auth is enabled, provide the base64 encoded password to use for the VMAgent client connection | `string` | `null` | no |
| <a name="input_basicauth_username"></a> [basicauth\_username](#input\_basicauth\_username) | If basic auth is enabled, provate the username for the VMAgent client | `string` | `null` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | The name of the Helm chart to install. Refer to https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-agent | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the Helm chart to install. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `null` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create a namespace for the deployment. | `bool` | `null` | no |
| <a name="input_gsa_audience"></a> [gsa\_audience](#input\_gsa\_audience) | If using GSA for auth to send metrics, the audience to use for token generation | `string` | `null` | no |
| <a name="input_gtoken_image"></a> [gtoken\_image](#input\_gtoken\_image) | The image URL to use for the gtoken container. | `string` | `null` | no |
| <a name="input_gtoken_image_version"></a> [gtoken\_image\_version](#input\_gtoken\_image\_version) | The image version to use for the gtoken container. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace used for the deployment. | `string` | `null` | no |
| <a name="input_oauth2_client_id"></a> [oauth2\_client\_id](#input\_oauth2\_client\_id) | If OAuth2 is enabled, provide the client id for the VMAgent client | `string` | `null` | no |
| <a name="input_oauth2_client_secret"></a> [oauth2\_client\_secret](#input\_oauth2\_client\_secret) | If OAuth2 is enabled, provide a base64 encoded secret to use for the VMAgent client connection. | `string` | `null` | no |
| <a name="input_oauth2_enabled"></a> [oauth2\_enabled](#input\_oauth2\_enabled) | Enable OAuth2 authentication for remote write endpoint. Requires providing a client id and secret. | `bool` | `null` | no |
| <a name="input_oauth2_token_url"></a> [oauth2\_token\_url](#input\_oauth2\_token\_url) | If OAuth2 is enabled, provide the token url to use for the VMAgent client connection | `string` | `null` | no |
| <a name="input_pods_scrape_namespaces"></a> [pods\_scrape\_namespaces](#input\_pods\_scrape\_namespaces) | A list of additional namespaces to scrape pod metrics. Defaults to "sn-system". | `list(string)` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_remote_write_urls"></a> [remote\_write\_urls](#input\_remote\_write\_urls) | A list of URL(s) for the remote write endpoint(s). | `list(string)` | `null` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |

## Outputs

No outputs.
