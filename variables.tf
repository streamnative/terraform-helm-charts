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

variable "enable_otel_collector" {
  default     = false
  description = "Enables Open Telemetry. Set to \"false\" by default."
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

variable "enable_vmagent" {
  default     = false
  description = "Enables the Victoria Metrics stack on the EKS cluster. Disabled by default"
  type        = bool
}

### Top-level Variables

#######
### Networking
#######

variable "service_domain" {
  default     = null
  description = "The DNS domain for external service endpoints. This must be set when enabling Istio or else the deployment will fail."
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
  default     = true
  description = "Create a namespace for the deployment. Defaults to \"true\"."
  type        = bool
}

variable "create_istio_system_namespace" {
  default     = false
  description = "Create a namespace where istio components will be installed."
  type        = bool
}

variable "istio_operator_namespace" {
  default     = "istio-operator"
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
  default     = true
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "kiali_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Kiali operator."
  type        = string
}

variable "kiali_operator_namespace" {
  default     = "kiali-operator"
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

variable "olm_enable_istio" {
  default     = false
  description = "Apply Istio authorization policies for OLM operators. Defaults to \"false\"."
  type        = bool
}

variable "olm_istio_system_namespace" {
  default     = "istio-system"
  description = "The namespace for Istio authorization policies. Set to the Istio root namespace for cluster-wide policies."
  type        = string
}

### Otel
variable "create_otel_collector_namespace" {
  default     = null
  description = "Wether or not to create the namespace used for the Otel Collector."
  type        = bool
}

variable "otel_collector_namespace" {
  default     = "sn-system"
  description = "The namespace used for the Otel Collector."
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
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "vector_agent_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment."
  type        = string
}

### Victoria Metrics
variable "create_vmagent_namespace" {
  default     = false
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "vmagent_namespace" {
  default     = "sn-system"
  description = "The namespace used for the operator deployment."
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

variable "istio_mesh_id" {
  default     = null
  description = "The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_cluster_name" {
  default     = null
  description = "The name of the kubernetes cluster where Istio is being configured. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_network" {
  default     = null
  description = "The name of network used for the Istio deployment."
  type        = string
}

variable "istio_profile" {
  default     = null
  description = "The path or name for an Istio profile to load. Set to the profile \"default\" if not specified."
  type        = string
}

variable "istio_operator_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "istio_revision_tag" {
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

variable "istio_trust_domain" {
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
  default     = null
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
### OpenTelemetry Collector Settings
#######
variable "otel_collector_chart_name" {
  default     = null
  description = "The name of the helm chart to install."
  type        = string
}

variable "otel_collector_chart_repository" {
  default     = null
  description = "The repository containing the helm chart to install."
  type        = string
}

variable "otel_collector_chart_version" {
  default     = null
  description = "The version of the helm chart to install."
  type        = string
}

variable "otel_collector_image_version" {
  default     = null
  description = "The version of the OpenTelemetry Collector image to use."
  type        = string
}

variable "otel_collector_release_name" {
  default     = null
  description = "The name of the Helm release."
  type        = string
}

variable "otel_collector_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "otel_collector_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "otel_collector_values" {
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

variable "vector_sink_endpoint" {
  default     = null
  description = "The endpoint to which Vector will send logs."
  type        = string
}

variable "vector_sink_name" {
  default     = null
  description = "The name of the vector sink."
  type        = string
}

variable "vector_sink_oauth_audience" {
  default     = null
  description = "The OAuth audience for the sink authorization config."
  type        = string
}

variable "vector_sink_oauth_credentials_url" {
  default     = null
  description = "A base64 encoded string containing the OAuth credentials URL for the sink authorization config."
  sensitive   = true
  type        = string
}

variable "vector_sink_oauth_issuer_url" {
  default     = null
  description = "The OAuth issuer URL for the sink authorization config."
  type        = string
}

variable "vector_sink_topic" {
  default     = null
  description = "The topic for the sink to which Vector will send logs."
  type        = string
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
variable "vmagent_basicauth_enabled" {
  default     = null
  description = "Enable basic auth for remote write endpoint. Requires providing a username and base64 encoded password."
  type        = bool
}

variable "vmagent_basicauth_username" {
  default     = null
  description = "If basic auth is enabled, provate the username for the VMAgent client"
  sensitive   = true
  type        = string
}

variable "vmagent_basicauth_password" {
  default     = null
  description = "If basic auth is enabled, provide the base64 encoded password to use for the VMAgent client connection"
  sensitive   = true
  type        = string
}

variable "vmagent_gsa_audience" {
  default     = null
  description = "If using GSA for auth to send metrics, the audience to use for token generation"
  sensitive   = true
  type        = string
}

variable "vmagent_chart_name" {
  default     = null
  description = "The name of the Helm chart to install"
  type        = string
}

variable "vmagent_chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install."
  type        = string
}

variable "vmagent_chart_version" {
  default     = null
  description = "The version of the Helm chart to install. Set to the submodule default."
  type        = string
}

variable "vmagent_oauth2_enabled" {
  default     = null
  description = "Enable OAuth2 authentication for remote write endpoint. Requires providing a client id and secret."
  type        = bool
}

variable "vmagent_oauth2_client_id" {
  default     = null
  description = "If OAuth2 is enabled, provide the client id for the VMAgent client"
  sensitive   = true
  type        = string
}

variable "vmagent_oauth2_client_secret" {
  default     = null
  description = "If OAuth2 is enabled, provide a base64 encoded secret to use for the VMAgent client connection."
  sensitive   = true
  type        = string
}

variable "vmagent_oauth2_token_url" {
  default     = null
  description = "If OAuth2 is enabled, provide the token url to use for the VMAgent client connection"
  type        = string
}

variable "vmagent_release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "vmagent_remote_write_urls" {
  default     = null
  description = "A list of URL(s) for the remote write endpoint(s)."
  type        = list(string)
}

variable "vmagent_settings" {
  default     = null
  description = "Additional key value settings which will be passed to the Helm chart values, e.g. { \"namespace\" = \"kube-system\" }."
  type        = map(any)
}

variable "vmagent_pods_scrape_namespaces" {
  default     = null
  description = "A list of additional namespaces to scrape pod metrics. Defaults to \"sn-system\"."
  type        = list(string)
}

variable "vmagent_timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vmagent_values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}
