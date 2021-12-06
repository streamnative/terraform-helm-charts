### Enable/Disable sub-modules
variable "enable_olm" {
  default     = false
  description = "Enables Operator Lifecycle Manager (OLM), and disables installing operators via Helm. OLM is disabled by default. Set to \"true\" to have OLM manage the operators."
  type        = bool
}

variable "enable_function_mesh_operator" {
  default     = true
  description = "Enables the StreamNative Function Mesh Operator. Set to \"true\" by default, but disabled if OLM is enabled."
  type        = bool
}

variable "enable_istio_operator" {
  default     = false
  description = "Enables the Istio Operator. Set to \"false\" by default."
  type        = bool
}

variable "enable_kiali_operator" {
  default     = false
  description = "Enables the Kiali Operator. Set to \"false\" by default."
  type        = bool
}

variable "enable_prometheus_operator" {
  default     = true
  description = "Enables the Prometheus Operator and other components via kube-stack-prometheus. Set to \"true\" by default."
  type        = bool
}

variable "enable_pulsar_operator" {
  default     = true
  description = "Enables the Pulsar Operator on the EKS cluster. Enabled by default, but disabled if var.disable_olm is set to `true`"
  type        = bool
}

variable "enable_vault_operator" {
  default     = true
  description = "Enables Hashicorp Vault on the EKS cluster."
  type        = bool
}

variable "enable_vector_agent" {
  default     = false
  description = "Enables the Vector Agent on the EKS cluster. Enabled by default, but must be passed a configuration in order to function"
  type        = bool
}

variable "enable_victoria_metrics_stack" {
  default     = false
  description = "Enables the Victoria Metrics stack on the EKS cluster. Disabled by default"
  type        = bool
}

variable "enable_victoria_metrics_auth" {
  default     = false
  description = "Enables the Victoria Metrics VMAuth on the EKS cluster. Disabled by default"
  type        = bool
}

### Top-level Variables

#######
### Networking
#######

variable "service_domain" {
  description = "The DNS domain for external service endpoints"
  type        = string
}

### Sub-module Variables

#######
### Namespace Management
#######

### Function Mesh
variable "create_function_mesh_operator_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "function_mesh_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

### Istio
variable "create_istio_operator_namespace" {
  default     = false
  description = "Create a namespace for the deployment. Defaults to \"true\"."
  type        = bool
}

variable "create_istio_system_namespace" {
  default     = false
  description = "Create a namespace where istio components will be installed."
  type        = bool
}

variable "istio_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Istio operator deployment"
  type        = string
}

variable "istio_system_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Istio components."
  type        = string
}

### Kiali
variable "create_kiali_operator_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "kiali_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Kiali operator."
  type        = string
}

variable "kiali_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Kiali operator deployment"
  type        = string
}

### OLM
variable "create_olm_install_namespace" {
  default     = false
  description = "Create a namespace for the deployment. Defaults to \"true\"."
  type        = bool
}

variable "create_olm_namespace" {
  default     = true
  description = "Whether or not to create the namespace used for OLM and its resources. Defaults to \"true\"."
  type        = bool
}

variable "olm_install_namespace" {
  default     = "sn-system"
  description = "The namespace used for installing the operators managed by OLM"
  type        = string
}

variable "olm_namespace" {
  default     = "olm"
  description = "The namespace used by OLM and its resources"
  type        = string
}

### Prometheus
variable "create_prometheus_operator_namespace" {
  default     = null
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "prometheus_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

### Pulsar
variable "create_pulsar_operator_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "pulsar_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

### Vault
variable "create_vault_operator_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "vault_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

### Vector
variable "create_vector_agent_namespace" {
  default     = false
  description = "Create a namespace for the deployment"
  type        = bool
}

variable "vector_agent_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment. Defaults to \"vector\" (recommended)"
  type        = string
}


### VictoriaMetrics
variable "create_victoria_metrics_auth_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "create_victoria_metrics_stack_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "victoria_metrics_auth_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "victoria_metrics_stack_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

###########################
### Sub-module Variables
### Most variables inherit the default values from their submodule, hence the use of `null` defaults
###########################

#######
### Function Mesh Settings
#######
variable "function_mesh_operator_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "function_mesh_operator_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "function_mesh_operator_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "function_mesh_operator_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "function_mesh_operator_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

#######
### Istio Settings
#######
variable "istio_operator_cluster_name" {
  default     = null
  description = "The name of the kubernetes cluster where Istio is being configured. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_operator_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "istio_operator_mesh_id" {
  default     = null
  description = "The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_operator_network" {
  default     = null
  description = "The name of network used for the Istio deployment."
  type        = string
}

variable "istio_operator_profile" {
  default     = null
  description = "The path or name for an Istio profile to load. Set to the profile \"default\" if not specified."
  type        = string
}

variable "istio_operator_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "istio_operator_revision_tag" {
  default     = null
  description = "The revision tag value use for the Istio label \"istio.io/rev\". Defaults to \"sn-stable\"."
  type        = string
}

variable "istio_operator_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "istio_operator_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "istio_operator_trust_domain" {
  default     = null
  description = "The trust domain used for the Istio operator, which corresponds to the root of a system. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_operator_values" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
}

#######
### Kiali Settings
#######
variable "create_kiali_cr" {
  default     = null
  description = "Create a Kiali CR for the Kiali deployment."
  type        = bool
}

variable "kiali_operator_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "kiali_operator_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "kiali_operator_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "kiali_operator_release_name" {
  default     = null
  description = "The name of the Kiali release"
  type        = string
}

variable "kiali_operator_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "kiali_operator_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

#######
### OLM Settings
#######
variable "olm_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "olm_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

variable "olm_registry" {
  description = "The registry containing StreamNative's operator catalog images"
  type        = string
}

variable "olm_subscription_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "olm_subscription_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

#######
### Prometheus Settings
#######
variable "prometheus_operator_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "prometheus_operator_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "prometheus_operator_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "prometheus_operator_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "prometheus_operator_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "prometheus_operator_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "prometheus_operator_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

#######
### Pulsar Settings
#######
variable "pulsar_operator_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "pulsar_operator_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "pulsar_operator_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "pulsar_operator_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "pulsar_operator_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "pulsar_operator_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "pulsar_operator_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

#######
### Vault Settings
#######
variable "vault_operator_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "vault_operator_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "vault_operator_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "vault_operator_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "vault_operator_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "vault_operator_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vault_operator_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}

#######
### Vector Settings
#######
variable "vector_agent_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "vector_agent_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install. See https://github.com/timberio/vector/tree/master/distribution/helm/vector-agent for available configuration options"
  type        = string
}

variable "vector_agent_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "vector_agent_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "vector_agent_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "vector_agent_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vector_agent_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}



#######
### VictioriaMetrics Settings
#######
variable "victoria_metrics_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "victoria_metrics_stack_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "victoria_metrics_stack_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack for available configuration options"
  type        = string
}

variable "victoria_metrics_stack_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "victoria_metrics_stack_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "victoria_metrics_stack_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "victoria_metrics_stack_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}

variable "victoria_metrics_auth_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "victoria_metrics_auth_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install."
  type        = string
}

variable "victoria_metrics_auth_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "victoria_metrics_auth_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "victoria_metrics_auth_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "victoria_metrics_auth_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}
