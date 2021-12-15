variable "prometheus_chart_name" {
  default     = "prometheus"
  description = "The name of the Helm chart to install."
  type        = string
}

variable "prometheus_chart_repository" {
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "The repository containing the Helm chart to install."
  type        = string
}

variable "prometheus_chart_version" {
  default     = "15.0.1"
  description = "The version of the Helm chart to install. See https://artifacthub.io/packages/helm/prometheus-community/prometheus."
  type        = string
}

variable "prometheus_release_name" {
  default     = "prometheus"
  description = "The name of the Prometheus release"
  type        = string
}

locals {
  prometheus_app_version = "2.31.1"

  # define the TLS settings for connecting to mesh-internal endpoints.
  # the certificates are provided by the Istio proxy and mounted below.
  prometheus_scrape_tls_config = {
    ca_file              = "/etc/prom-certs/root-cert.pem"
    cert_file            = "/etc/prom-certs/cert-chain.pem"
    key_file             = "/etc/prom-certs/key.pem"
    insecure_skip_verify = true
  }

  scrape_relabel_common = [
    { # retain pod labels
      action = "labelmap"
      regex  = "__meta_kubernetes_pod_label_(.+)"
    },
    { # retain pod namespace
      source_labels = ["__meta_kubernetes_namespace"]
      action        = "replace"
      target_label  = "namespace"
    },
    { # retain pod name
      source_labels = ["__meta_kubernetes_pod_name"]
      action        = "replace"
      target_label  = "pod"
    },
    { # filter non-ready pods
      source_labels = ["__meta_kubernetes_pod_phase"]
      regex         = "Pending|Succeeded|Failed|Completed"
      action        = "drop"
    },
  ]

  # scrape the istio control plane metrics
  # note: envoy metrics are always plaintext
  scrape_config_istiod = {
    job_name = "istiod"
    kubernetes_sd_configs = [{
      role = "endpoints"
      namespaces = {
        names = [local.istio_system_namespace]
      }
    }]
    relabel_configs = [
      {
        source_labels = ["__meta_kubernetes_service_name", "__meta_kubernetes_endpoint_port_name"]
        action        = "keep"
        regex         = "istiod-${local.istio_revision_tag};http-monitoring"
      }
    ]
  }

  # scrape the istio CNI plugin metrics
  scrape_config_istio_cni = {
    job_name = "istio-cni"
    kubernetes_sd_configs = [{
      role = "pod"
      namespaces = {
        names = [local.istio_system_namespace]
      }
    }]
    relabel_configs = concat([
      {
        source_labels = ["__meta_kubernetes_pod_label_k8s_app"]
        action        = "keep"
        regex         = "istio-cni-node"
      },
      {
        source_labels = ["__address__"]
        action        = "replace"
        regex         = "([^:]+)(?::\\d+)?"
        replacement   = "$1:15014"
        target_label  = "__address__"
      }
    ], local.scrape_relabel_common)
  }

  # scrape the istio proxy sidecar metrics
  # note: envoy metrics are always plaintext
  scrape_config_envoy_stats = {
    job_name              = "envoy-stats"
    metrics_path          = "/stats/prometheus"
    kubernetes_sd_configs = [{ role = "pod" }]
    relabel_configs = concat([
      { # filter: envoy metrics port
        source_labels = ["__meta_kubernetes_pod_container_port_name"]
        action        = "keep"
        regex         = ".*-envoy-prom"
      }
    ], local.scrape_relabel_common)
  }

  # scrape Kiali appliation metrics
  scrape_config_kiali = {
    job_name   = "kiali"
    scheme     = "https"
    tls_config = local.prometheus_scrape_tls_config
    kubernetes_sd_configs = [{
      role = "pod"
      namespaces = {
        names = [local.kiali_namespace]
      }
    }]
    relabel_configs = concat([
      {
        source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_name", "__meta_kubernetes_pod_label_app_kubernetes_io_instance", "__meta_kubernetes_pod_container_port_name"]
        action        = "keep"
        regex         = "kiali;kiali;http-metrics"
      }
    ], local.scrape_relabel_common)
  }

  scrape_configs = [
    local.scrape_config_istiod,
    local.scrape_config_istio_cni,
    local.scrape_config_envoy_stats,
    local.scrape_config_kiali
  ]

  prometheus_values = yamlencode({
    alertmanager = {
      enabled = false
    }
    kubeStateMetrics = {
      enabled = false
    }
    nodeExporter = {
      enabled = false
    }
    pushgateway = {
      enabled = false
    }
    server = {
      global = {
        query_log_file = "/data/query.log"
      }
      podLabels = {
        "service.istio.io/canonical-name"     = var.prometheus_release_name
        "service.istio.io/canonical-revision" = local.prometheus_app_version
      }
      podAnnotations = {
        # expose Prometheus API as a mesh-internal endpoint (mTLS)
        "traffic.sidecar.istio.io/includeInboundPorts" : "9090"

        # bypass envoy for outgoing connections to scrape endpoints.
        # This is necessary to take control of whether mTLS is used,
        # because envoy doesn't know to use mTLS when connecting directly to a pod.
        # If the endpoint is mesh-internal, configure the job to use the istio certificates.
        "traffic.sidecar.istio.io/includeOutboundIPRanges" : ""

        # Mount the istio certificates into a local volume to be used by scrape jobs.
        "proxy.istio.io/config" : yamlencode({
          proxyMetadata : {
            "OUTPUT_CERTS" : "/etc/istio-output-certs"
          }
        })
        "sidecar.istio.io/userVolumeMount" : jsonencode([{
          name : "istio-certs"
          mountPath : "/etc/istio-output-certs"
        }])
      }
      extraVolumeMounts = [{
        mountPath = "/etc/prom-certs/"
        name : "istio-certs"
      }]
      extraVolumes = [{
        name = "istio-certs"
        emptyDir = {
          medium = "Memory"
        }
      }]
    }
    serverFiles = {
      "prometheus.yml" : {
        rule_files = [
          "/etc/config/recording_rules.yml",
          "/etc/config/alerting_rules.yml"
        ]
        # suppress the default scrape configs (use ours instead)
        scrape_configs : local.scrape_configs
      }
    }
  })
}

resource "helm_release" "prometheus" {
  count            = var.enable_istio_operator ? 1 : 0
  atomic           = local.atomic
  chart            = var.prometheus_chart_name
  repository       = var.prometheus_chart_repository
  version          = var.prometheus_chart_version
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = false
  name             = var.prometheus_release_name
  namespace        = local.istio_system_namespace
  timeout          = local.timeout
  values           = [local.prometheus_values]

  depends_on = [
    resource.helm_release.mesh
  ]
}
