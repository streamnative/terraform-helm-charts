### Enable/Disable sub-module flags

variable "disable_olm" {
  default     = true
  description = "Enables Operator Lifecycle Manager (OLM), and disables installing operators via Helm. OLM is disabled by default. Set to \"false\" to have OLM manage the operators."
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

variable "istio_operator_chart_name" {
  default     = "istio-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_repository" {
  default     = "https://kubernetes-charts.banzaicloud.com"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_version" {
  default     = "0.0.88"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "istio_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "istio_operator_namespace" {
  default     = "istio-system"
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

variable "olm_sn_image" {
  description = "The registry containing StreamNative's operator catalog image"
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
  type	      = string
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
  default     = "1.13.0"
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
