# Istio Operator
This is an opinionated module for installing and configuring Istio, along with the Kiali console, for StreamNative Cloud.

Note that this module does not install all of the services necessary for Kiali to function, such as Prometheus, Jaeger, or (in some cases) Grafana. Refer to the [official docs](https://kiali.io/docs/configuration/p8s-jaeger-grafana/) for instructions if these components do not exist on your cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.istio_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kiali](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kiali_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mesh](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.istio_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Default's to "true". | `bool` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. | `bool` | `null` | no |
| <a name="input_create_istio_operator_namespace"></a> [create\_istio\_operator\_namespace](#input\_create\_istio\_operator\_namespace) | Create a namespace where istio operator will be installed. | `bool` | `null` | no |
| <a name="input_create_istio_system_namespace"></a> [create\_istio\_system\_namespace](#input\_create\_istio\_system\_namespace) | Create a namespace where istio components will be installed. | `bool` | `null` | no |
| <a name="input_create_kiali_cr"></a> [create\_kiali\_cr](#input\_create\_kiali\_cr) | Create a Kiali CR for the Kiali deployment. Defaults to "true". | `bool` | `null` | no |
| <a name="input_create_kiali_operator_namespace"></a> [create\_kiali\_operator\_namespace](#input\_create\_kiali\_operator\_namespace) | Create a namespace for the deployment. Defaults to "true". | `bool` | `null` | no |
| <a name="input_enable_istio_operator"></a> [enable\_istio\_operator](#input\_enable\_istio\_operator) | Enables the Istio Operator for installation. Can be disabled if you only need to install Kiali. | `bool` | `null` | no |
| <a name="input_enable_kiali_operator"></a> [enable\_kiali\_operator](#input\_enable\_kiali\_operator) | Enables the Kiali Operator for installation. Can be disabled if you only need to install Istio. | `bool` | `null` | no |
| <a name="input_istio_chart_name"></a> [istio\_chart\_name](#input\_istio\_chart\_name) | The name of the Helm chart to install. | `string` | `null` | no |
| <a name="input_istio_chart_repository"></a> [istio\_chart\_repository](#input\_istio\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `null` | no |
| <a name="input_istio_chart_version"></a> [istio\_chart\_version](#input\_istio\_chart\_version) | The version of the Helm chart to install. See https://github.com/stevehipwell/helm-charts/tree/master/charts/istio-operator for available versions. | `string` | `null` | no |
| <a name="input_istio_cluster_name"></a> [istio\_cluster\_name](#input\_istio\_cluster\_name) | The name of the kubernetes cluster where Istio is being installed. | `string` | `null` | no |
| <a name="input_istio_gateway_certificate_hosts"></a> [istio\_gateway\_certificate\_hosts](#input\_istio\_gateway\_certificate\_hosts) | The certificate host(s) for the Istio gateway TLS certificate. | `list(string)` | `[]` | no |
| <a name="input_istio_gateway_certificate_issuer"></a> [istio\_gateway\_certificate\_issuer](#input\_istio\_gateway\_certificate\_issuer) | The certificate issuer for the Istio gateway TLS certificate. | <pre>object({<br>    group = string<br>    kind  = string<br>    name  = string<br>  })</pre> | `null` | no |
| <a name="input_istio_gateway_certificate_name"></a> [istio\_gateway\_certificate\_name](#input\_istio\_gateway\_certificate\_name) | The certificate name for Istio gateway TLS. | `string` | `null` | no |
| <a name="input_istio_ingress_gateway_service_annotations"></a> [istio\_ingress\_gateway\_service\_annotations](#input\_istio\_ingress\_gateway\_service\_annotations) | Kubernetes annotations to add to the Istio IngressGateway Service. | `map(string)` | `null` | no |
| <a name="input_istio_mesh_id"></a> [istio\_mesh\_id](#input\_istio\_mesh\_id) | The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environment. | `string` | `null` | no |
| <a name="input_istio_network"></a> [istio\_network](#input\_istio\_network) | The network used for the Istio mesh. | `string` | `null` | no |
| <a name="input_istio_operator_namespace"></a> [istio\_operator\_namespace](#input\_istio\_operator\_namespace) | The namespace where the Istio Operator is installed. | `string` | `null` | no |
| <a name="input_istio_profile"></a> [istio\_profile](#input\_istio\_profile) | The path or name for an Istio profile to load. Set to the profile "default" if not specified. | `string` | `null` | no |
| <a name="input_istio_release_name"></a> [istio\_release\_name](#input\_istio\_release\_name) | The name of the Istio release | `string` | `null` | no |
| <a name="input_istio_revision_tag"></a> [istio\_revision\_tag](#input\_istio\_revision\_tag) | The revision tag value use for the Istio label "istio.io/rev". | `string` | `null` | no |
| <a name="input_istio_settings"></a> [istio\_settings](#input\_istio\_settings) | Additional settings which will be passed to the Helm chart values. | `map(any)` | `null` | no |
| <a name="input_istio_system_namespace"></a> [istio\_system\_namespace](#input\_istio\_system\_namespace) | The namespace used for the Istio components. | `string` | `null` | no |
| <a name="input_istio_trust_domain"></a> [istio\_trust\_domain](#input\_istio\_trust\_domain) | The trust domain used by Istio, which corresponds to the the trust root of a system. | `string` | `null` | no |
| <a name="input_istio_values"></a> [istio\_values](#input\_istio\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_kiali_gateway_hosts"></a> [kiali\_gateway\_hosts](#input\_kiali\_gateway\_hosts) | The external FQDN(s) to expose Kiali on | `list(string)` | `[]` | no |
| <a name="input_kiali_gateway_tls_secret"></a> [kiali\_gateway\_tls\_secret](#input\_kiali\_gateway\_tls\_secret) | The name of the TLS secret to use at the gateway.  The secret must be located in the Istio gateway's namespace. | `string` | `null` | no |
| <a name="input_kiali_namespace"></a> [kiali\_namespace](#input\_kiali\_namespace) | The namespace used for the Kiali CR. | `string` | `null` | no |
| <a name="input_kiali_operator_chart_name"></a> [kiali\_operator\_chart\_name](#input\_kiali\_operator\_chart\_name) | The name of the Helm chart to install. | `string` | `null` | no |
| <a name="input_kiali_operator_chart_repository"></a> [kiali\_operator\_chart\_repository](#input\_kiali\_operator\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `null` | no |
| <a name="input_kiali_operator_chart_version"></a> [kiali\_operator\_chart\_version](#input\_kiali\_operator\_chart\_version) | The version of the Helm chart to install. See https://github.com/kiali/helm-charts/tree/v1.42/kiali-operator for configuration options, and note that newer versions will be in their corresponding branch in the git repo. | `string` | `null` | no |
| <a name="input_kiali_operator_namespace"></a> [kiali\_operator\_namespace](#input\_kiali\_operator\_namespace) | The namespace used for the Kiali operator. | `string` | `null` | no |
| <a name="input_kiali_operator_release_name"></a> [kiali\_operator\_release\_name](#input\_kiali\_operator\_release\_name) | The name of the Kiali release. | `string` | `null` | no |
| <a name="input_kiali_operator_settings"></a> [kiali\_operator\_settings](#input\_kiali\_operator\_settings) | Additional settings which will be passed to the Helm chart values. See https://github.com/kiali/helm-charts/blob/v1.42/kiali-operator/values.yaml for available options. | `map(any)` | `null` | no |
| <a name="input_kiali_operator_values"></a> [kiali\_operator\_values](#input\_kiali\_operator\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_kiali_release_name"></a> [kiali\_release\_name](#input\_kiali\_release\_name) | The name of the Kiali release. | `string` | `null` | no |
| <a name="input_kiali_values"></a> [kiali\_values](#input\_kiali\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_prometheus_chart_name"></a> [prometheus\_chart\_name](#input\_prometheus\_chart\_name) | The name of the Helm chart to install. | `string` | `"prometheus"` | no |
| <a name="input_prometheus_chart_repository"></a> [prometheus\_chart\_repository](#input\_prometheus\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_prometheus_chart_version"></a> [prometheus\_chart\_version](#input\_prometheus\_chart\_version) | The version of the Helm chart to install. See https://artifacthub.io/packages/helm/prometheus-community/prometheus. | `string` | `"15.0.1"` | no |
| <a name="input_prometheus_release_name"></a> [prometheus\_release\_name](#input\_prometheus\_release\_name) | The name of the Prometheus release | `string` | `"prometheus"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation. | `number` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->