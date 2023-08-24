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

# terraform-helm-charts
This repository contains Terraform managed Helm charts used by StreamNative Platform, contained within the [modules](https://github.com/streamnative/terraform-helm-charts/tree/master/modules) directory. For more information on the Helm provider for Terraform, please refer to the [official documentation](https://registry.terraform.io/providers/hashicorp/helm/latest/docs).

## Example Usage
The [submodules](https://github.com/streamnative/terraform-helm-charts/tree/master/modules) in this repo can be used in a standalone fashion. However, the root module (contained in the [root `main.tf` file](https://github.com/streamnative/terraform-helm-charts/blob/master/main.tf)) [composes](https://www.terraform.io/docs/language/modules/develop/composition.html) all of the submodules to be used in concert with each other, depending on your configuration needs.

Here is a simple example on how to use the root module in this repo for the common StreamNative Platform use case. It will install the Vault, Prometheus, Pulsar, and Function Mesh operators:

```hcl
data "aws_eks_cluster" "cluster" {
  name = "my_eks_cluster_id"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "my_eks_cluster_id"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  insecure               = false
}

provider "helm" {
  kubernetes {
    config_path = "./my-eks-kube-config"
  }
}

module "sn_bootstrap" {
  source = "streamnative/charts/helm"

  enable_vault_operator         = true
  enable_function_mesh_operator = true
  enable_prometheus_operator    = true
  enable_pulsar_operator        = true
}
```

To apply the configuration above, simply run:

```shell
terraform init && terraform apply
```

## Why are all the variable defaults null?
The submodules contained in this repo are typically composed in the root module, and as such many of a submodules variables get duplicated in the root module. 

This introduces a problem where we don't want to also duplicate default values in both places, i.e. managing a default value in the root module _and_ in the submodule, as they are difficult to synchronize and have historically drifted away from each other.

In a perfect world, the approach we would like to take is:

- Have the root module's variables that map to a submodule's variables default to `null`
- Have the submodule's variables default to their expected value

However, when we do this, the root module _overrides_ the submodule's default value with `null`, rather than respect it and treat `null` as an omission. This unfortunately is [expected](https://github.com/hashicorp/terraform/issues/24142#issuecomment-646393631) behavior](https://github.com/hashicorp/terraform/issues/24142#issuecomment-646393631) in Terraform, where `null` is actually a valid value in some module configurations (instead of being "the absence of a value", like we want it to be and also like the Terraform documentation states).

To work around this, we set the default values in _both_ the root module and submodules to `null`, then use a `locals()` configuration in the submodule to manage the expected default values. To illustrate, here is a simple example:

Submodule: `streamnative/terraform-helm-charts/modules/submodule_a/main.tf`
```hcl
variable "input_1" {
  default = null
  type    = string
}

locals (
  input_1 = var.input_1 != null ? : var.input_1 : "my_default_value" // This is where we set the default value
)

output "submodule_a" {
  value = local.input_1
}
```

Root module: `streamnative/terraform-helm-charts/main.tf`
```hcl
variable "submodule_a_input_1" {
  default = null
}

module "submodule_a" {
  source = "./modules/submodule_a"

  input_1 = var.submodule_a_input_1
}
```

And in a module composition, we could override the default value:
```hcl
module "terraform-helm-charts" {
  source = "streamnative/terraform-helm-charts"

  submodule_a_input = "my_custom_value" 
}
```

While this pattern has [some limitations](https://github.com/hashicorp/terraform/issues/24142#issuecomment-938106778), it is a sufficient workaround for our (opinionated) needs in these modules.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.6.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-manager-agent"></a> [cloud-manager-agent](#module\_cloud-manager-agent) | ./modules/cloud-manager-agent | n/a |
| <a name="module_function_mesh_operator"></a> [function\_mesh\_operator](#module\_function\_mesh\_operator) | ./modules/function-mesh-operator | n/a |
| <a name="module_istio_operator"></a> [istio\_operator](#module\_istio\_operator) | ./modules/istio-operator | n/a |
| <a name="module_olm"></a> [olm](#module\_olm) | ./modules/operator-lifecycle-manager | n/a |
| <a name="module_olm_subscriptions"></a> [olm\_subscriptions](#module\_olm\_subscriptions) | ./modules/olm-subscriptions | n/a |
| <a name="module_otel_collector"></a> [otel\_collector](#module\_otel\_collector) | ./modules/otel-collector | n/a |
| <a name="module_prometheus_operator"></a> [prometheus\_operator](#module\_prometheus\_operator) | ./modules/prometheus-operator | n/a |
| <a name="module_pulsar_operator"></a> [pulsar\_operator](#module\_pulsar\_operator) | ./modules/pulsar-operator | n/a |
| <a name="module_vault_operator"></a> [vault\_operator](#module\_vault\_operator) | ./modules/vault-operator | n/a |
| <a name="module_vector_agent"></a> [vector\_agent](#module\_vector\_agent) | ./modules/vector-agent | n/a |
| <a name="module_vmagent"></a> [vmagent](#module\_vmagent) | ./modules/victoria-metrics-agent | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cma_environment"></a> [cma\_environment](#input\_cma\_environment) | Whether this is for a test, staging, or production environment. | `string` | `"production"` | no |
| <a name="input_cma_namespace"></a> [cma\_namespace](#input\_cma\_namespace) | The namespace used by cloud-manager-agent and its resources | `string` | `"sn-system"` | no |
| <a name="input_cma_settings"></a> [cma\_settings](#input\_cma\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_cma_values"></a> [cma\_values](#input\_cma\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")` | `any` | `null` | no |
| <a name="input_create_function_mesh_operator_namespace"></a> [create\_function\_mesh\_operator\_namespace](#input\_create\_function\_mesh\_operator\_namespace) | Create a namespace for the deployment. | `bool` | `false` | no |
| <a name="input_create_istio_operator_namespace"></a> [create\_istio\_operator\_namespace](#input\_create\_istio\_operator\_namespace) | Create a namespace for the deployment. Defaults to "true". | `bool` | `true` | no |
| <a name="input_create_istio_system_namespace"></a> [create\_istio\_system\_namespace](#input\_create\_istio\_system\_namespace) | Create a namespace where istio components will be installed. | `bool` | `false` | no |
| <a name="input_create_kiali_cr"></a> [create\_kiali\_cr](#input\_create\_kiali\_cr) | Create a Kiali CR for the Kiali deployment. | `bool` | `null` | no |
| <a name="input_create_kiali_operator_namespace"></a> [create\_kiali\_operator\_namespace](#input\_create\_kiali\_operator\_namespace) | Create a namespace for the deployment. | `bool` | `true` | no |
| <a name="input_create_olm_install_namespace"></a> [create\_olm\_install\_namespace](#input\_create\_olm\_install\_namespace) | Create a namespace for the deployment. Defaults to "true". | `bool` | `false` | no |
| <a name="input_create_olm_namespace"></a> [create\_olm\_namespace](#input\_create\_olm\_namespace) | Whether or not to create the namespace used for OLM and its resources. Defaults to "true". | `bool` | `true` | no |
| <a name="input_create_otel_collector_namespace"></a> [create\_otel\_collector\_namespace](#input\_create\_otel\_collector\_namespace) | Wether or not to create the namespace used for the Otel Collector. | `bool` | `null` | no |
| <a name="input_create_prometheus_operator_namespace"></a> [create\_prometheus\_operator\_namespace](#input\_create\_prometheus\_operator\_namespace) | Create a namespace for the deployment. | `bool` | `null` | no |
| <a name="input_create_pulsar_operator_namespace"></a> [create\_pulsar\_operator\_namespace](#input\_create\_pulsar\_operator\_namespace) | Create a namespace for the deployment. | `bool` | `false` | no |
| <a name="input_create_vault_operator_namespace"></a> [create\_vault\_operator\_namespace](#input\_create\_vault\_operator\_namespace) | Create a namespace for the deployment. | `bool` | `false` | no |
| <a name="input_create_vector_agent_namespace"></a> [create\_vector\_agent\_namespace](#input\_create\_vector\_agent\_namespace) | Create a namespace for the deployment. | `bool` | `false` | no |
| <a name="input_create_vmagent_namespace"></a> [create\_vmagent\_namespace](#input\_create\_vmagent\_namespace) | Create a namespace for the deployment. | `bool` | `false` | no |
| <a name="input_enable_cma"></a> [enable\_cma](#input\_enable\_cma) | Enables Cloud Manager Agent. Disabled by default. | `bool` | `false` | no |
| <a name="input_enable_function_mesh_operator"></a> [enable\_function\_mesh\_operator](#input\_enable\_function\_mesh\_operator) | Enables the StreamNative Function Mesh Operator. Set to "true" by default, but disabled if OLM is enabled. | `bool` | `true` | no |
| <a name="input_enable_istio_operator"></a> [enable\_istio\_operator](#input\_enable\_istio\_operator) | Enables the Istio Operator. Set to "false" by default. | `bool` | `false` | no |
| <a name="input_enable_kiali_operator"></a> [enable\_kiali\_operator](#input\_enable\_kiali\_operator) | Enables the Kiali Operator. Set to "false" by default. | `bool` | `false` | no |
| <a name="input_enable_olm"></a> [enable\_olm](#input\_enable\_olm) | Enables Operator Lifecycle Manager (OLM), and disables installing operators via Helm. OLM is disabled by default. Set to "true" to have OLM manage the operators. | `bool` | `false` | no |
| <a name="input_enable_otel_collector"></a> [enable\_otel\_collector](#input\_enable\_otel\_collector) | Enables Open Telemetry. Set to "false" by default. | `bool` | `false` | no |
| <a name="input_enable_prometheus_operator"></a> [enable\_prometheus\_operator](#input\_enable\_prometheus\_operator) | Enables the Prometheus Operator and other components via kube-stack-prometheus. Set to "true" by default. | `bool` | `true` | no |
| <a name="input_enable_pulsar_operator"></a> [enable\_pulsar\_operator](#input\_enable\_pulsar\_operator) | Enables the Pulsar Operator on the EKS cluster. Enabled by default, but disabled if var.disable\_olm is set to `true` | `bool` | `true` | no |
| <a name="input_enable_vault_operator"></a> [enable\_vault\_operator](#input\_enable\_vault\_operator) | Enables Hashicorp Vault on the EKS cluster. | `bool` | `true` | no |
| <a name="input_enable_vector_agent"></a> [enable\_vector\_agent](#input\_enable\_vector\_agent) | Enables the Vector Agent on the EKS cluster. Enabled by default, but must be passed a configuration in order to function | `bool` | `false` | no |
| <a name="input_enable_vmagent"></a> [enable\_vmagent](#input\_enable\_vmagent) | Enables the Victoria Metrics stack on the EKS cluster. Disabled by default | `bool` | `false` | no |
| <a name="input_function_mesh_operator_chart_name"></a> [function\_mesh\_operator\_chart\_name](#input\_function\_mesh\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_function_mesh_operator_chart_repository"></a> [function\_mesh\_operator\_chart\_repository](#input\_function\_mesh\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `null` | no |
| <a name="input_function_mesh_operator_chart_version"></a> [function\_mesh\_operator\_chart\_version](#input\_function\_mesh\_operator\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_function_mesh_operator_namespace"></a> [function\_mesh\_operator\_namespace](#input\_function\_mesh\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_function_mesh_operator_release_name"></a> [function\_mesh\_operator\_release\_name](#input\_function\_mesh\_operator\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_function_mesh_operator_settings"></a> [function\_mesh\_operator\_settings](#input\_function\_mesh\_operator\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_function_mesh_operator_timeout"></a> [function\_mesh\_operator\_timeout](#input\_function\_mesh\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_function_mesh_operator_values"></a> [function\_mesh\_operator\_values](#input\_function\_mesh\_operator\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_install_prometheus_cluster_role"></a> [install\_prometheus\_cluster\_role](#input\_install\_prometheus\_cluster\_role) | Installs the well-known Prometheus server ClusterRole resource on the cluster. | `bool` | `null` | no |
| <a name="input_istio_cluster_name"></a> [istio\_cluster\_name](#input\_istio\_cluster\_name) | The name of the kubernetes cluster where Istio is being configured. This is required when "enable\_istio\_operator" is set to "true". | `string` | `null` | no |
| <a name="input_istio_mesh_id"></a> [istio\_mesh\_id](#input\_istio\_mesh\_id) | The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments. This is required when "enable\_istio\_operator" is set to "true". | `string` | `null` | no |
| <a name="input_istio_network"></a> [istio\_network](#input\_istio\_network) | The name of network used for the Istio deployment. | `string` | `null` | no |
| <a name="input_istio_operator_chart_name"></a> [istio\_operator\_chart\_name](#input\_istio\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_istio_operator_chart_repository"></a> [istio\_operator\_chart\_repository](#input\_istio\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `null` | no |
| <a name="input_istio_operator_chart_version"></a> [istio\_operator\_chart\_version](#input\_istio\_operator\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_istio_operator_namespace"></a> [istio\_operator\_namespace](#input\_istio\_operator\_namespace) | The namespace used for the Istio operator deployment | `string` | `"istio-operator"` | no |
| <a name="input_istio_operator_release_name"></a> [istio\_operator\_release\_name](#input\_istio\_operator\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_istio_operator_settings"></a> [istio\_operator\_settings](#input\_istio\_operator\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_istio_operator_timeout"></a> [istio\_operator\_timeout](#input\_istio\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_istio_operator_values"></a> [istio\_operator\_values](#input\_istio\_operator\_values) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `any` | `null` | no |
| <a name="input_istio_profile"></a> [istio\_profile](#input\_istio\_profile) | The path or name for an Istio profile to load. Set to the profile "default" if not specified. | `string` | `null` | no |
| <a name="input_istio_revision_tag"></a> [istio\_revision\_tag](#input\_istio\_revision\_tag) | The revision tag value use for the Istio label "istio.io/rev". Defaults to "sn-stable". | `string` | `null` | no |
| <a name="input_istio_system_namespace"></a> [istio\_system\_namespace](#input\_istio\_system\_namespace) | The namespace used for the Istio components. | `string` | `"sn-system"` | no |
| <a name="input_istio_trust_domain"></a> [istio\_trust\_domain](#input\_istio\_trust\_domain) | The trust domain used for the Istio operator, which corresponds to the root of a system. This is required when "enable\_istio\_operator" is set to "true". | `string` | `null` | no |
| <a name="input_kiali_namespace"></a> [kiali\_namespace](#input\_kiali\_namespace) | The namespace used for the Kiali operator. | `string` | `"sn-system"` | no |
| <a name="input_kiali_operator_chart_name"></a> [kiali\_operator\_chart\_name](#input\_kiali\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_kiali_operator_chart_repository"></a> [kiali\_operator\_chart\_repository](#input\_kiali\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `null` | no |
| <a name="input_kiali_operator_chart_version"></a> [kiali\_operator\_chart\_version](#input\_kiali\_operator\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_kiali_operator_namespace"></a> [kiali\_operator\_namespace](#input\_kiali\_operator\_namespace) | The namespace used for the Kiali operator deployment | `string` | `"kiali-operator"` | no |
| <a name="input_kiali_operator_release_name"></a> [kiali\_operator\_release\_name](#input\_kiali\_operator\_release\_name) | The name of the Kiali release | `string` | `null` | no |
| <a name="input_kiali_operator_settings"></a> [kiali\_operator\_settings](#input\_kiali\_operator\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_kiali_operator_values"></a> [kiali\_operator\_values](#input\_kiali\_operator\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_olm_enable_istio"></a> [olm\_enable\_istio](#input\_olm\_enable\_istio) | Apply Istio authorization policies for OLM operators. Defaults to "false". | `bool` | `false` | no |
| <a name="input_olm_install_namespace"></a> [olm\_install\_namespace](#input\_olm\_install\_namespace) | The namespace used for installing the operators managed by OLM | `string` | `"sn-system"` | no |
| <a name="input_olm_istio_system_namespace"></a> [olm\_istio\_system\_namespace](#input\_olm\_istio\_system\_namespace) | The namespace for Istio authorization policies. Set to the Istio root namespace for cluster-wide policies. | `string` | `"istio-system"` | no |
| <a name="input_olm_namespace"></a> [olm\_namespace](#input\_olm\_namespace) | The namespace used by OLM and its resources | `string` | `"olm"` | no |
| <a name="input_olm_registry"></a> [olm\_registry](#input\_olm\_registry) | The registry containing StreamNative's operator catalog images | `string` | `null` | no |
| <a name="input_olm_settings"></a> [olm\_settings](#input\_olm\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_olm_subscription_settings"></a> [olm\_subscription\_settings](#input\_olm\_subscription\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_olm_subscription_values"></a> [olm\_subscription\_values](#input\_olm\_subscription\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_olm_values"></a> [olm\_values](#input\_olm\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_otel_collector_chart_name"></a> [otel\_collector\_chart\_name](#input\_otel\_collector\_chart\_name) | The name of the helm chart to install. | `string` | `null` | no |
| <a name="input_otel_collector_chart_repository"></a> [otel\_collector\_chart\_repository](#input\_otel\_collector\_chart\_repository) | The repository containing the helm chart to install. | `string` | `null` | no |
| <a name="input_otel_collector_chart_version"></a> [otel\_collector\_chart\_version](#input\_otel\_collector\_chart\_version) | The version of the helm chart to install. | `string` | `null` | no |
| <a name="input_otel_collector_image_version"></a> [otel\_collector\_image\_version](#input\_otel\_collector\_image\_version) | The version of the OpenTelemetry Collector image to use. | `string` | `null` | no |
| <a name="input_otel_collector_namespace"></a> [otel\_collector\_namespace](#input\_otel\_collector\_namespace) | The namespace used for the Otel Collector. | `string` | `"sn-system"` | no |
| <a name="input_otel_collector_release_name"></a> [otel\_collector\_release\_name](#input\_otel\_collector\_release\_name) | The name of the Helm release. | `string` | `null` | no |
| <a name="input_otel_collector_settings"></a> [otel\_collector\_settings](#input\_otel\_collector\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_otel_collector_timeout"></a> [otel\_collector\_timeout](#input\_otel\_collector\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_otel_collector_values"></a> [otel\_collector\_values](#input\_otel\_collector\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_prometheus_operator_chart_name"></a> [prometheus\_operator\_chart\_name](#input\_prometheus\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_prometheus_operator_chart_repository"></a> [prometheus\_operator\_chart\_repository](#input\_prometheus\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `null` | no |
| <a name="input_prometheus_operator_chart_version"></a> [prometheus\_operator\_chart\_version](#input\_prometheus\_operator\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_prometheus_operator_namespace"></a> [prometheus\_operator\_namespace](#input\_prometheus\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_prometheus_operator_release_name"></a> [prometheus\_operator\_release\_name](#input\_prometheus\_operator\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_prometheus_operator_settings"></a> [prometheus\_operator\_settings](#input\_prometheus\_operator\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_prometheus_operator_timeout"></a> [prometheus\_operator\_timeout](#input\_prometheus\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_pulsar_operator_chart_name"></a> [pulsar\_operator\_chart\_name](#input\_pulsar\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_pulsar_operator_chart_repository"></a> [pulsar\_operator\_chart\_repository](#input\_pulsar\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `null` | no |
| <a name="input_pulsar_operator_chart_version"></a> [pulsar\_operator\_chart\_version](#input\_pulsar\_operator\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_pulsar_operator_namespace"></a> [pulsar\_operator\_namespace](#input\_pulsar\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_pulsar_operator_release_name"></a> [pulsar\_operator\_release\_name](#input\_pulsar\_operator\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_pulsar_operator_settings"></a> [pulsar\_operator\_settings](#input\_pulsar\_operator\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_pulsar_operator_timeout"></a> [pulsar\_operator\_timeout](#input\_pulsar\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_pulsar_operator_values"></a> [pulsar\_operator\_values](#input\_pulsar\_operator\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_service_domain"></a> [service\_domain](#input\_service\_domain) | The DNS domain for external service endpoints. This must be set when enabling Istio or else the deployment will fail. | `string` | `null` | no |
| <a name="input_vault_operator_chart_name"></a> [vault\_operator\_chart\_name](#input\_vault\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_vault_operator_chart_repository"></a> [vault\_operator\_chart\_repository](#input\_vault\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `null` | no |
| <a name="input_vault_operator_chart_version"></a> [vault\_operator\_chart\_version](#input\_vault\_operator\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_vault_operator_namespace"></a> [vault\_operator\_namespace](#input\_vault\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_vault_operator_release_name"></a> [vault\_operator\_release\_name](#input\_vault\_operator\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_vault_operator_settings"></a> [vault\_operator\_settings](#input\_vault\_operator\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_vault_operator_timeout"></a> [vault\_operator\_timeout](#input\_vault\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_vault_operator_values"></a> [vault\_operator\_values](#input\_vault\_operator\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_vector_agent_chart_name"></a> [vector\_agent\_chart\_name](#input\_vector\_agent\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_vector_agent_chart_repository"></a> [vector\_agent\_chart\_repository](#input\_vector\_agent\_chart\_repository) | The repository containing the Helm chart to install. See https://github.com/timberio/vector/tree/master/distribution/helm/vector-agent for available configuration options | `string` | `null` | no |
| <a name="input_vector_agent_chart_version"></a> [vector\_agent\_chart\_version](#input\_vector\_agent\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_vector_agent_namespace"></a> [vector\_agent\_namespace](#input\_vector\_agent\_namespace) | The namespace used for the operator deployment. | `string` | `"sn-system"` | no |
| <a name="input_vector_agent_release_name"></a> [vector\_agent\_release\_name](#input\_vector\_agent\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_vector_agent_settings"></a> [vector\_agent\_settings](#input\_vector\_agent\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_vector_agent_timeout"></a> [vector\_agent\_timeout](#input\_vector\_agent\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_vector_agent_values"></a> [vector\_agent\_values](#input\_vector\_agent\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")` | `any` | `null` | no |
| <a name="input_vector_sink_endpoint"></a> [vector\_sink\_endpoint](#input\_vector\_sink\_endpoint) | The endpoint to which Vector will send logs. | `string` | `null` | no |
| <a name="input_vector_sink_name"></a> [vector\_sink\_name](#input\_vector\_sink\_name) | The name of the vector sink. | `string` | `null` | no |
| <a name="input_vector_sink_oauth_audience"></a> [vector\_sink\_oauth\_audience](#input\_vector\_sink\_oauth\_audience) | The OAuth audience for the sink authorization config. | `string` | `null` | no |
| <a name="input_vector_sink_oauth_credentials_url"></a> [vector\_sink\_oauth\_credentials\_url](#input\_vector\_sink\_oauth\_credentials\_url) | A base64 encoded string containing the OAuth credentials URL for the sink authorization config. | `string` | `null` | no |
| <a name="input_vector_sink_oauth_issuer_url"></a> [vector\_sink\_oauth\_issuer\_url](#input\_vector\_sink\_oauth\_issuer\_url) | The OAuth issuer URL for the sink authorization config. | `string` | `null` | no |
| <a name="input_vector_sink_topic"></a> [vector\_sink\_topic](#input\_vector\_sink\_topic) | The topic for the sink to which Vector will send logs. | `string` | `null` | no |
| <a name="input_vmagent_basicauth_enabled"></a> [vmagent\_basicauth\_enabled](#input\_vmagent\_basicauth\_enabled) | Enable basic auth for remote write endpoint. Requires providing a username and base64 encoded password. | `bool` | `null` | no |
| <a name="input_vmagent_basicauth_password"></a> [vmagent\_basicauth\_password](#input\_vmagent\_basicauth\_password) | If basic auth is enabled, provide the base64 encoded password to use for the VMAgent client connection | `string` | `null` | no |
| <a name="input_vmagent_basicauth_username"></a> [vmagent\_basicauth\_username](#input\_vmagent\_basicauth\_username) | If basic auth is enabled, provate the username for the VMAgent client | `string` | `null` | no |
| <a name="input_vmagent_chart_name"></a> [vmagent\_chart\_name](#input\_vmagent\_chart\_name) | The name of the Helm chart to install | `string` | `null` | no |
| <a name="input_vmagent_chart_repository"></a> [vmagent\_chart\_repository](#input\_vmagent\_chart\_repository) | The repository containing the Helm chart to install. | `string` | `null` | no |
| <a name="input_vmagent_chart_version"></a> [vmagent\_chart\_version](#input\_vmagent\_chart\_version) | The version of the Helm chart to install. Set to the submodule default. | `string` | `null` | no |
| <a name="input_vmagent_gsa_audience"></a> [vmagent\_gsa\_audience](#input\_vmagent\_gsa\_audience) | If using GSA for auth to send metrics, the audience to use for token generation | `string` | `null` | no |
| <a name="input_vmagent_gtoken_image"></a> [vmagent\_gtoken\_image](#input\_vmagent\_gtoken\_image) | The image URL to use for the gtoken container | `string` | `null` | no |
| <a name="input_vmagent_gtoken_image_version"></a> [vmagent\_gtoken\_image\_version](#input\_vmagent\_gtoken\_image\_version) | The image version to use for the gtoken container | `string` | `null` | no |
| <a name="input_vmagent_namespace"></a> [vmagent\_namespace](#input\_vmagent\_namespace) | The namespace used for the operator deployment. | `string` | `"sn-system"` | no |
| <a name="input_vmagent_oauth2_client_id"></a> [vmagent\_oauth2\_client\_id](#input\_vmagent\_oauth2\_client\_id) | If OAuth2 is enabled, provide the client id for the VMAgent client | `string` | `null` | no |
| <a name="input_vmagent_oauth2_client_secret"></a> [vmagent\_oauth2\_client\_secret](#input\_vmagent\_oauth2\_client\_secret) | If OAuth2 is enabled, provide a base64 encoded secret to use for the VMAgent client connection. | `string` | `null` | no |
| <a name="input_vmagent_oauth2_enabled"></a> [vmagent\_oauth2\_enabled](#input\_vmagent\_oauth2\_enabled) | Enable OAuth2 authentication for remote write endpoint. Requires providing a client id and secret. | `bool` | `null` | no |
| <a name="input_vmagent_oauth2_token_url"></a> [vmagent\_oauth2\_token\_url](#input\_vmagent\_oauth2\_token\_url) | If OAuth2 is enabled, provide the token url to use for the VMAgent client connection | `string` | `null` | no |
| <a name="input_vmagent_pods_scrape_namespaces"></a> [vmagent\_pods\_scrape\_namespaces](#input\_vmagent\_pods\_scrape\_namespaces) | A list of additional namespaces to scrape pod metrics. Defaults to "sn-system". | `list(string)` | `null` | no |
| <a name="input_vmagent_release_name"></a> [vmagent\_release\_name](#input\_vmagent\_release\_name) | The name of the helm release | `string` | `null` | no |
| <a name="input_vmagent_remote_write_urls"></a> [vmagent\_remote\_write\_urls](#input\_vmagent\_remote\_write\_urls) | A list of URL(s) for the remote write endpoint(s). | `list(string)` | `null` | no |
| <a name="input_vmagent_settings"></a> [vmagent\_settings](#input\_vmagent\_settings) | Additional key value settings which will be passed to the Helm chart values, e.g. { "namespace" = "kube-system" }. | `map(any)` | `null` | no |
| <a name="input_vmagent_timeout"></a> [vmagent\_timeout](#input\_vmagent\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `null` | no |
| <a name="input_vmagent_values"></a> [vmagent\_values](#input\_vmagent\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")` | `any` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->