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
  default     = 200
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "istio_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "istio_operator_cluster_name" {
  default     = null
  description = "The name of the kubernetes cluster where Istio is being configured. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_operator_chart_name" {
  default     = "istio-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_repository" {
  default     = "https://stevehipwell.github.io/helm-charts/"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_version" {
  default     = "2.3.4"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "istio_operator_mesh_id" {
  default     = null
  description = "The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "istio_operator_release_name" {
  default     = "istio-operator"
  description = "The name of the helm release"
  type        = string
}

variable "istio_operator_revision_tag" {
  default     = "sn-stable"
  description = "The revision tag value use for the Istio label \"istio.io/rev\"."
  type        = string
}

variable "istio_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "istio_operator_timeout" {
  default     = 200
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "istio_operator_trust_domain" {
  default     = null
  description = "The trust domain used for the Istio operator, which corresponds to the root of a system. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "olm_catalog_namespace" {
  default     = "olm"
  description = "The namespace used for the OLM catalog services"
  type        = string
}

variable "kiali_operator_chart_name" {
  default     = "kiali-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "kiali_operator_chart_repository" {
  default     = "https://kiali.org/helm-charts"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "kiali_operator_chart_version" {
  default     = "1.42.0"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "kiali_operator_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Kiali operator."
  type        = string
}

variable "kiali_operator_release_name" {
  default     = "kiali-operator"
  description = "The name of the Kiali release"
  type        = string
}

variable "kiali_operator_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
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
  default     = "19.2.2"
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
  default     = 200
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
  default     = 200
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
  default     = 200
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
  default     = 200
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vector_agent_values" {
  default     = []
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}

variable "victoria_metrics_chart_repository" {
  default     = "https://victoriametrics.github.io/helm-charts/"
  description = "The repository containing the Helm chart to install. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack for available configuration options"
  type        = string
}

variable "victoria_metrics_timeout" {
  default     = 200
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "victoria_metrics_stack_chart_name" {
  default     = "victoria-metrics-k8s-stack"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "victoria_metrics_stack_create_namespace" {
  default     = true
  description = "Create a namespace for the operator. Defaults to \"true\""
  type        = bool
}

variable "victoria_metrics_stack_chart_version" {
  default     = "0.4.5"
  description = "The version of the Helm chart to install. See"
  type        = string
}

variable "victoria_metrics_stack_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "victoria_metrics_stack_release_name" {
  default     = "vmstack"
  description = "The name of the helm release"
  type        = string
}

variable "victoria_metrics_stack_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "victoria_metrics_stack_values" {
  default     = []
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}

variable "victoria_metrics_auth_chart_name" {
  default     = "victoria-metrics-auth"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "victoria_metrics_auth_create_namespace" {
  default     = true
  description = "Create a namespace for the operator. Defaults to \"true\""
  type        = bool
}

variable "victoria_metrics_auth_chart_version" {
  default     = "0.2.31"
  description = "The version of the Helm chart to install. See"
  type        = string
}

variable "victoria_metrics_auth_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment"
  type        = string
}

variable "victoria_metrics_auth_release_name" {
  default     = "vmauth"
  description = "The name of the helm release"
  type        = string
}

variable "victoria_metrics_auth_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "victoria_metrics_auth_values" {
  default     = []
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}
