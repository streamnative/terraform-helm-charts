# terraform-helm-charts
This repository contains Terraform managed Helm charts used by StreamNative Platform. For more information on the Helm provider for Terraform, please refer to the [official documentation](https://registry.terraform.io/providers/hashicorp/helm/latest/docs).

## Example Usage

The `main.tf` file in the root of this repository contains an example of how to use these modules. 

A simple example of how to use one of the modules is shown below:

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
  config_path            = "./my-eks-kube-config"
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
  enable_istio_operator         = true
  enable_prometheus_operator    = true
  enable_pulsar_operator        = true
  enable_vector_agent           = true
  enable_victoria_metrics       = true

  vector_agent_vaules           = [ file("${path.module}/my-vector-agent-values.yaml") ]

}
```

To apply the configuration above, initialize the Terraform from the example above:

```shell
terraform init
```

Run a plan to validate what's being created:

```shell
terraform plan
```

Apply the configuration:
```shell
terraform apply
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_function_mesh_operator"></a> [function\_mesh\_operator](#module\_function\_mesh\_operator) | ./modules/function-mesh-operator | n/a |
| <a name="module_istio_operator"></a> [istio\_operator](#module\_istio\_operator) | ./modules/istio-operator | n/a |
| <a name="module_olm"></a> [olm](#module\_olm) | ./modules/operator-lifecycle-manager | n/a |
| <a name="module_olm_subscriptions"></a> [olm\_subscriptions](#module\_olm\_subscriptions) | ./modules/olm-subscriptions | n/a |
| <a name="module_prometheus_operator"></a> [prometheus\_operator](#module\_prometheus\_operator) | ./modules/prometheus-operator | n/a |
| <a name="module_pulsar_operator"></a> [pulsar\_operator](#module\_pulsar\_operator) | ./modules/pulsar-operator | n/a |
| <a name="module_vault_operator"></a> [vault\_operator](#module\_vault\_operator) | ./modules/vault-operator | n/a |
| <a name="module_vector_agent"></a> [vector\_agent](#module\_vector\_agent) | ./modules/vector-agent | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_function_mesh_operator"></a> [enable\_function\_mesh\_operator](#input\_enable\_function\_mesh\_operator) | Enables the StreamNative Function Mesh Operator. Set to "true" by default, but disabled if OLM is enabled. | `bool` | `true` | no |
| <a name="input_enable_istio_operator"></a> [enable\_istio\_operator](#input\_enable\_istio\_operator) | Enables the Istio Operator. Set to "true" by default, but disabled if OLM is enabled. | `bool` | `true` | no |
| <a name="input_enable_olm"></a> [enable\_olm](#input\_enable\_olm) | Enables Operator Lifecycle Manager (OLM), and disables installing operators via Helm. OLM is disabled by default. Set to "true" to have OLM manage the operators. | `bool` | `false` | no |
| <a name="input_enable_prometheus_operator"></a> [enable\_prometheus\_operator](#input\_enable\_prometheus\_operator) | Enables the Prometheus Operator. Set to "true" by default, but disabled if OLM is enabled. | `bool` | `true` | no |
| <a name="input_enable_pulsar_operator"></a> [enable\_pulsar\_operator](#input\_enable\_pulsar\_operator) | Enables the Pulsar Operator on the EKS cluster. Enabled by default, but disabled if var.disable\_olm is set to `true` | `bool` | `true` | no |
| <a name="input_enable_vault_operator"></a> [enable\_vault\_operator](#input\_enable\_vault\_operator) | Enables Hashicorp Vault on the EKS cluster. | `bool` | `true` | no |
| <a name="input_enable_vector_agent"></a> [enable\_vector\_agent](#input\_enable\_vector\_agent) | Enables the Vector Agent on the EKS cluster. Enabled by default, but must be passed a configuration in order to function | `bool` | `true` | no |
| <a name="input_function_mesh_operator_chart_name"></a> [function\_mesh\_operator\_chart\_name](#input\_function\_mesh\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `"function-mesh-operator"` | no |
| <a name="input_function_mesh_operator_chart_repository"></a> [function\_mesh\_operator\_chart\_repository](#input\_function\_mesh\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `"https://charts.streamnative.io"` | no |
| <a name="input_function_mesh_operator_chart_version"></a> [function\_mesh\_operator\_chart\_version](#input\_function\_mesh\_operator\_chart\_version) | The version of the Helm chart to install | `string` | `"0.1.7"` | no |
| <a name="input_function_mesh_operator_cleanup_on_fail"></a> [function\_mesh\_operator\_cleanup\_on\_fail](#input\_function\_mesh\_operator\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_function_mesh_operator_namespace"></a> [function\_mesh\_operator\_namespace](#input\_function\_mesh\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_function_mesh_operator_release_name"></a> [function\_mesh\_operator\_release\_name](#input\_function\_mesh\_operator\_release\_name) | The name of the helm release | `string` | `"function-mesh-operator"` | no |
| <a name="input_function_mesh_operator_settings"></a> [function\_mesh\_operator\_settings](#input\_function\_mesh\_operator\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_function_mesh_operator_timeout"></a> [function\_mesh\_operator\_timeout](#input\_function\_mesh\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |
| <a name="input_istio_operator_cleanup_on_fail"></a> [istio\_operator\_cleanup\_on\_fail](#input\_istio\_operator\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_istio_operator_namespace"></a> [istio\_operator\_namespace](#input\_istio\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"kube-system"` | no |
| <a name="input_istio_operator_release_name"></a> [istio\_operator\_release\_name](#input\_istio\_operator\_release\_name) | The name of the helm release | `string` | `"istio-operator"` | no |
| <a name="input_istio_operator_settings"></a> [istio\_operator\_settings](#input\_istio\_operator\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_istio_operator_timeout"></a> [istio\_operator\_timeout](#input\_istio\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |
| <a name="input_olm_namespace"></a> [olm\_namespace](#input\_olm\_namespace) | The namespace used for the OLM and its resources  | `string` | `"olm"` | no |
| <a name="input_sn_operator_namespace"></a> [sn\_operator\_namespace](#input\_sn\_operator\_namespace) | The namespace used for running SN operators | `string` | `"sn-system"` | no |
| <a name="input_olm_operators_namespace"></a> [olm\_operators\_namespace](#input\_olm\_operators\_namespace) | The namespace where OLM will install the operators | `string` | `"operators"` | no |
| <a name="input_olm_registry"></a> [olm\_registry](#input\_olm\_registry) | The registry containing StreamNative's operator catalog images | `string` | `""` | no |
| <a name="input_olm_settings"></a> [olm\_settings](#input\_olm\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_olm_subscription_settings"></a> [olm\_subscription\_settings](#input\_olm\_subscription\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_prometheus_operator_chart_name"></a> [prometheus\_operator\_chart\_name](#input\_prometheus\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `"kube-prometheus-stack"` | no |
| <a name="input_prometheus_operator_chart_repository"></a> [prometheus\_operator\_chart\_repository](#input\_prometheus\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_prometheus_operator_chart_version"></a> [prometheus\_operator\_chart\_version](#input\_prometheus\_operator\_chart\_version) | The version of the Helm chart to install | `string` | `"16.12.1"` | no |
| <a name="input_prometheus_operator_cleanup_on_fail"></a> [prometheus\_operator\_cleanup\_on\_fail](#input\_prometheus\_operator\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_prometheus_operator_namespace"></a> [prometheus\_operator\_namespace](#input\_prometheus\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_prometheus_operator_release_name"></a> [prometheus\_operator\_release\_name](#input\_prometheus\_operator\_release\_name) | The name of the helm release | `string` | `"kube-prometheus-stack"` | no |
| <a name="input_prometheus_operator_settings"></a> [prometheus\_operator\_settings](#input\_prometheus\_operator\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_prometheus_operator_timeout"></a> [prometheus\_operator\_timeout](#input\_prometheus\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |
| <a name="input_pulsar_operator_chart_name"></a> [pulsar\_operator\_chart\_name](#input\_pulsar\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `"pulsar-operator"` | no |
| <a name="input_pulsar_operator_chart_repository"></a> [pulsar\_operator\_chart\_repository](#input\_pulsar\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `"https://charts.streamnative.io"` | no |
| <a name="input_pulsar_operator_chart_version"></a> [pulsar\_operator\_chart\_version](#input\_pulsar\_operator\_chart\_version) | The version of the Helm chart to install | `string` | `"0.7.2"` | no |
| <a name="input_pulsar_operator_cleanup_on_fail"></a> [pulsar\_operator\_cleanup\_on\_fail](#input\_pulsar\_operator\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_pulsar_operator_namespace"></a> [pulsar\_operator\_namespace](#input\_pulsar\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_pulsar_operator_release_name"></a> [pulsar\_operator\_release\_name](#input\_pulsar\_operator\_release\_name) | The name of the helm release | `string` | `"pulsar-operator"` | no |
| <a name="input_pulsar_operator_settings"></a> [pulsar\_operator\_settings](#input\_pulsar\_operator\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_pulsar_operator_timeout"></a> [pulsar\_operator\_timeout](#input\_pulsar\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |
| <a name="input_vault_operator_chart_name"></a> [vault\_operator\_chart\_name](#input\_vault\_operator\_chart\_name) | The name of the Helm chart to install | `string` | `"vault-operator"` | no |
| <a name="input_vault_operator_chart_repository"></a> [vault\_operator\_chart\_repository](#input\_vault\_operator\_chart\_repository) | The repository containing the Helm chart to install | `string` | `"https://kubernetes-charts.banzaicloud.com"` | no |
| <a name="input_vault_operator_chart_version"></a> [vault\_operator\_chart\_version](#input\_vault\_operator\_chart\_version) | The version of the Helm chart to install | `string` | `"1.13.2"` | no |
| <a name="input_vault_operator_cleanup_on_fail"></a> [vault\_operator\_cleanup\_on\_fail](#input\_vault\_operator\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails | `bool` | `true` | no |
| <a name="input_vault_operator_namespace"></a> [vault\_operator\_namespace](#input\_vault\_operator\_namespace) | The namespace used for the operator deployment | `string` | `"sn-system"` | no |
| <a name="input_vault_operator_release_name"></a> [vault\_operator\_release\_name](#input\_vault\_operator\_release\_name) | The name of the helm release | `string` | `"vault-operator"` | no |
| <a name="input_vault_operator_settings"></a> [vault\_operator\_settings](#input\_vault\_operator\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `null` | no |
| <a name="input_vault_operator_timeout"></a> [vault\_operator\_timeout](#input\_vault\_operator\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `600` | no |
| <a name="input_vector_agent_chart_name"></a> [vector\_agent\_chart\_name](#input\_vector\_agent\_chart\_name) | The name of the Helm chart to install | `string` | `"vector-agent"` | no |
| <a name="input_vector_agent_chart_repository"></a> [vector\_agent\_chart\_repository](#input\_vector\_agent\_chart\_repository) | The repository containing the Helm chart to install. See https://github.com/timberio/vector/tree/master/distribution/helm/vector-agent for available configuration options | `string` | `"https://helm.vector.dev"` | no |
| <a name="input_vector_agent_chart_version"></a> [vector\_agent\_chart\_version](#input\_vector\_agent\_chart\_version) | The version of the Helm chart to install. See | `string` | `"0.17.0"` | no |
| <a name="input_vector_agent_create_namespace"></a> [vector\_agent\_create\_namespace](#input\_vector\_agent\_create\_namespace) | Create a namespace for the operator. Defaults to "true", as it's recommended to install Vector into its own namespace | `bool` | `true` | no |
| <a name="input_vector_agent_namespace"></a> [vector\_agent\_namespace](#input\_vector\_agent\_namespace) | The namespace used for the operator deployment. Defaults to "vector" (recommended) | `string` | `"vector"` | no |
| <a name="input_vector_agent_release_name"></a> [vector\_agent\_release\_name](#input\_vector\_agent\_release\_name) | The name of the helm release | `string` | `"vector-agent"` | no |
| <a name="input_vector_agent_settings"></a> [vector\_agent\_settings](#input\_vector\_agent\_settings) | Additional settings which will be passed to the Helm chart values | `map(any)` | `{}` | no |
| <a name="input_vector_agent_timeout"></a> [vector\_agent\_timeout](#input\_vector\_agent\_timeout) | Time in seconds to wait for any individual kubernetes operation | `number` | `300` | no |
| <a name="input_vector_agent_values"></a> [vector\_agent\_values](#input\_vector\_agent\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")` | `list` | `[]` | no |

## Outputs

No outputs.

