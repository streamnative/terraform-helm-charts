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

# otel-collector
This module manages the helm installation of the OpenTelemetry Collector.

While this pattern has [some limitations](https://github.com/hashicorp/terraform/issues/24142#issuecomment-938106778), it is a sufficient workaround for our (opinionated) needs in these modules.

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
| [helm_release.helm_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Defaults are configured in the locals block of this module's main.tf file. | `bool` | `null` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | The name of the Helm chart to install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository containing the Helm chart to install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the Helm chart to install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. Defaults are configured in the locals block of this module's main.tf file. | `bool` | `null` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create a namespace for the deployment. Defaults are configured in the locals block of this module's main.tf file. | `bool` | `null` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The image tag of the OpenTelemetry Collector to be used by the Helm install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace used for the operator deployment. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values. Defaults are configured in the locals block of this module's main.tf file. | `map(any)` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation. Defaults are configured in the locals block of this module's main.tf file. | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. Defaults are configured in the locals block of this module's main.tf file. | `any` | `null` | no |

## Outputs

No outputs.
