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
  default     = true
  description = "Enables the Istio Operator. Set to \"true\" by default, but disabled if OLM is enabled."
  type        = bool
}

variable "enable_prometheus_operator" {
  default     = true
  description = "Enables the Prometheus Operator. Set to \"true\" by default, but disabled if OLM is enabled."
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
  default = true
  description = "Enables the Vector Agent on the EKS cluster. Enabled by default, but must be passed a configuration in order to function"
  type = bool
}

### Sub-module Variables

variable "function_mesh_operator_chart_name" {
  default     = "function-mesh-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_chart_repository" {
  default     = "https://charts.streamnative.io"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_chart_version" {
  default     = "0.1.7"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "function_mesh_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "function_mesh_operator_release_name" {
  default     = "function-mesh-operator"
  description = "The name of the helm release"
  type        = string
}

variable "function_mesh_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "function_mesh_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "istio_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "istio_operator_namespace" {
  default     = "kube-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "istio_operator_release_name" {
  default     = "istio-operator"
  description = "The name of the helm release"
  type        = string
}

variable "istio_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "istio_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "olm_catalog_namespace" {
  default     = "olm"
  description = "The namespace used for the OLM catalog services"
  type        = string
}

variable "olm_namespace" {
  default     = "olm"
  description = "The namespace used by OLM and its resources"
  type        = string
}

variable "olm_operators_namespace" {
  default     = "operators"
  description = "The namespace where OLM will install the operators"
  type        = string
}

variable "olm_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "olm_registry" {
  default     = ""
  description = "The registry containing StreamNative's operator catalog images"
  type        = string
}

variable "olm_subscription_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "prometheus_operator_chart_name" {
  default     = "kube-prometheus-stack"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "prometheus_operator_chart_repository" {
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "prometheus_operator_chart_version" {
  default     = "16.12.1"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "prometheus_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "prometheus_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "prometheus_operator_release_name" {
  default     = "kube-prometheus-stack"
  description = "The name of the helm release"
  type        = string
}

variable "prometheus_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "prometheus_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "pulsar_operator_chart_name" {
  default     = "pulsar-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "pulsar_operator_chart_repository" {
  default     = "https://charts.streamnative.io"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "pulsar_operator_chart_version" {
  default     = "0.7.2"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "pulsar_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "pulsar_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "pulsar_operator_release_name" {
  default     = "pulsar-operator"
  description = "The name of the helm release"
  type        = string
}

variable "pulsar_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "pulsar_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vault_operator_chart_name" {
  default     = "vault-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "vault_operator_chart_repository" {
  default     = "https://kubernetes-charts.banzaicloud.com"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "vault_operator_chart_version" {
  default     = "1.13.2"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "vault_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "vault_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "vault_operator_release_name" {
  default     = "vault-operator"
  description = "The name of the helm release"
  type        = string
}

variable "vault_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "vault_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vector_agent_chart_name" {
  default     = "vector-agent"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "vector_agent_chart_repository" {
  default     = "https://helm.vector.dev"
  description = "The repository containing the Helm chart to install. See https://github.com/timberio/vector/tree/master/distribution/helm/vector-agent for available configuration options"
  type        = string
}

variable "vector_agent_create_namespace" {
  default     = true
  description = "Create a namespace for the operator. Defaults to \"true\", as it's recommended to install Vector into its own namespace"
  type        = bool
}

variable "vector_agent_chart_version" {
  default     = "0.17.0"
  description = "The version of the Helm chart to install. See"
  type        = string
}

variable "vector_agent_namespace" {
  default     = "vector"
  description = "The namespace used for the operator deployment. Defaults to \"vector\" (recommended)"
  type        = string
}

variable "vector_agent_release_name" {
  default     = "vector-agent"
  description = "The name of the helm release"
  type        = string
}

variable "vector_agent_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "vector_agent_timeout" {
  default     = 300
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vector_agent_values" {
  default = []
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}