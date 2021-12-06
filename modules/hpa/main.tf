#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

resource "kubernetes_manifest" "clusterrole_scaling_prometheus" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "scaling-prometheus"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "nodes",
          "nodes/proxy",
          "services",
          "endpoints",
          "pods",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "configmaps",
        ]
        "verbs" = [
          "get",
        ]
      },
      {
        "nonResourceURLs" = [
          "/metrics",
        ]
        "verbs" = [
          "get",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resourceNames" = [
          "scaling-prometheus-headless:9090",
        ]
        "resources" = [
          "services/proxy",
        ]
        "verbs" = [
          "*",
        ]
      },
      {
        "nonResourceURLs" = [
          "/api/v1/namespaces/sn-system/services/scaling-prometheus-headless:9090/proxy/*",
        ]
        "verbs" = [
          "*",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "serviceaccount_sn_system_scaling_prometheus" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "scaling-prometheus"
      "namespace" = var.scaling_prometheus_namespace
    }
  }
}

resource "kubernetes_manifest" "clusterrolebinding_scaling_prometheus" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "scaling-prometheus"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "scaling-prometheus"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "scaling-prometheus"
        "namespace" = var.scaling_prometheus_namespace
      },
    ]
  }
}

# scrape config for prometheus scraping metrics for HPA
# currently only container_spec_cpu_shares, container_cpu_usage_seconds_total, container_network_receive_bytes_total,
# container_network_transmit_bytes_total, container_fs_reads_bytes_total, container_fs_writes_bytes_total
# from cadvisor and kubelet_volume_stats_available_bytes, kubelet_volume_stats_capacity_bytes from kubelet
resource "kubernetes_manifest" "secret_sn_system_scaling_conf" {
  computed_fields = ["stringData"]
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Secret"
    "metadata" = {
      "name" = "scaling-conf"
      "namespace" = var.scaling_prometheus_namespace
    }
    "stringData" = {
      "scrape.yaml" = <<-EOT
      - job_name: kubernetes-cadvisor
        scheme: https
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        kubernetes_sd_configs:
          - role: node
        relabel_configs:
          - target_label: __address__
            replacement: kubernetes.default.svc.cluster.local:443
          - source_labels: [__meta_kubernetes_node_name]
            regex: (.+)
            replacement: /api/v1/nodes/$${1}/proxy/metrics/cadvisor
            target_label: __metrics_path__
          - action: labelmap
            regex: __meta_kubernetes_node_label_(.+)
        metric_relabel_configs:
          - source_labels:
              - __name__
            regex: (container_spec_cpu_shares|container_cpu_usage_seconds_total|container_network_receive_bytes_total|container_network_transmit_bytes_total|container_fs_reads_bytes_total|container_fs_writes_bytes_total)
            action: keep
          - source_labels:
              - namespace
            regex: (sn-system|kube-system|olm|cert-manager)
            action: drop
      - job_name: 'kubernetes-nodes'
        scheme: https
        kubernetes_sd_configs:
          - role: node
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        relabel_configs:
          - action: labelmap
            regex: __meta_kubernetes_node_label_(.+)
          - target_label: __address__
            replacement: kubernetes.default.svc:443
          - source_labels: [__meta_kubernetes_node_name]
            regex: (.+)
            target_label: __metrics_path__
            replacement: /api/v1/nodes/$${1}/proxy/metrics
        metric_relabel_configs:
          - source_labels:
              - __name__
            regex: (kubelet_volume_stats_available_bytes|kubelet_volume_stats_capacity_bytes)
            action: keep
          - source_labels:
              - namespace
            regex: (sn-system|kube-system|olm|cert-manager)
            action: drop
      EOT
    }
    "type" = "Opaque"
  }
}

resource "kubernetes_manifest" "prometheus_sn_system_scaling_prometheus" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind" = "Prometheus"
    "metadata" = {
      "name" = "scaling-prometheus"
      "namespace" = var.scaling_prometheus_namespace
    }
    "spec" = {
      "additionalScrapeConfigs" = {
        "key" = "scrape.yaml"
        "name" = "scaling-conf"
      }
      "evaluationInterval" = var.scaling_prometheus_evaluation_interval
      "image" = "prom/prometheus"
      "podMetadata" = {
        "labels" = {
          "app" = "prometheus"
          "cloud.streamnative.io/role" = "scaling-prometheus"
        }
      }
      "replicas" = var.scaling_prometheus_replicas
      "resources" = {
        "limits" = {
          "cpu" = var.scaling_prometheus_cpu_limit
          "memory" = var.scaling_prometheus_memory_limit
        }
      }
      "retention" = var.scaling_prometheus_retention_period
      "scrapeInterval" = var.scaling_prometheus_scrape_interval
      "securityContext" = {
        "fsGroup" = 2000
        "runAsNonRoot" = true
        "runAsUser" = 1000
      }
      "serviceAccountName" = "scaling-prometheus"
      "serviceMonitorSelector" = {
        "matchLabels" = {
          "app" = "prometheus"
        }
      }
      "version" = var.scaling_prometheus_version
    }
  }
}

resource "kubernetes_manifest" "service_sn_system_scaling_prometheus" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "scaling-prometheus"
      "namespace" = var.scaling_prometheus_namespace
    }
    "spec" = {
      "ports" = [
        {
          "port" = 9090
          "protocol" = "TCP"
          "targetPort" = 9090
        },
      ]
      "selector" = {
        "cloud.streamnative.io/role" = "scaling-prometheus"
      }
    }
  }
}


# generate a private key for internal issuer's cert
resource "tls_private_key" "private_key" {
  algorithm   = "RSA"
}

# generate a self-signed cert for internal issuer
resource "tls_self_signed_cert" "issuer_cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
    common_name  = "CA Issuer"
  }

  validity_period_hours = 87600

  is_ca_certificate = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]

  depends_on = [
    tls_private_key.private_key
  ]
}

resource "kubernetes_manifest" "secret_issuer_cert" {
  computed_fields = ["stringData"]
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Secret"
    "metadata" = {
      "name" = "issuer-cert"
      "namespace" = var.cert_manager_namespace
    }
    "stringData" = {
      "tls.crt" = tls_self_signed_cert.issuer_cert.cert_pem,
      "tls.key" = tls_private_key.private_key.private_key_pem,
    }
    "type" = "Opaque"
  }

  depends_on = [
    tls_self_signed_cert.issuer_cert
  ]
}

# internal issuer
resource "kubernetes_manifest" "clusterissuer_ca_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "ClusterIssuer"
    "metadata" = {
      "name" = "ca-issuer"
    }
    "spec" = {
      "ca" = {
        "secretName" = "issuer-cert"
      }
    }
  }

  depends_on = [
    kubernetes_manifest.secret_issuer_cert
  ]
}

# cert for kube-aggregator to use for communicating with custom metric server
resource "kubernetes_manifest" "certificate_sn_system_custom_metrics_server" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Certificate"
    "metadata" = {
      "name" = "custom-metrics-server"
      "namespace" = var.metric_server_namespace
    }
    "spec" = {
      "dnsNames" = [
        "custom-metrics-apiserver",
        "custom-metrics-apiserver.monitoring",
        "custom-metrics-apiserver.monitoring.svc",
      ]
      "issuerRef" = {
        "group" = "cert-manager.io"
        "kind" = "ClusterIssuer"
        "name" = "ca-issuer"
      }
      "secretName" = "custom-metrics-server"
    }
  }

  depends_on = [
    kubernetes_manifest.clusterissuer_ca_issuer
  ]
}

resource "kubernetes_manifest" "serviceaccount_sn_system_custom_metrics_apiserver" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "custom-metrics-apiserver"
      "namespace" = var.metric_server_namespace
    }
  }
}

resource "kubernetes_manifest" "clusterrolebinding_custom_metrics_system_auth_delegator" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "custom-metrics:system:auth-delegator"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "system:auth-delegator"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "custom-metrics-apiserver"
        "namespace" = var.metric_server_namespace
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_custom_metrics_server_resources" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "custom-metrics-server-resources"
    }
    "rules" = [
      {
        "apiGroups" = [
          "custom.metrics.k8s.io",
          "external.metrics.k8s.io",
        ]
        "resources" = [
          "*",
        ]
        "verbs" = [
          "*",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_hpa_controller_custom_metrics" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "hpa-controller-custom-metrics"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "custom-metrics-server-resources"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "horizontal-pod-autoscaler"
        "namespace" = "kube-system"
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_kube_system_custom_metrics_auth_reader" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "name" = "custom-metrics-auth-reader"
      "namespace" = var.metric_server_namespace
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "extension-apiserver-authentication-reader"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "custom-metrics-apiserver"
        "namespace" = var.metric_server_namespace
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_custom_metrics_resource_reader" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "custom-metrics-resource-reader"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
          "nodes",
          "nodes/stats",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_custom_metrics_resource_reader" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "custom-metrics-resource-reader"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "custom-metrics-resource-reader"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "custom-metrics-apiserver"
        "namespace" = var.metric_server_namespace
      },
    ]
  }
}

resource "kubernetes_manifest" "deployment_sn_system_custom_metrics_apiserver" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "custom-metrics-apiserver"
      }
      "name" = "custom-metrics-apiserver"
      "namespace" = var.metric_server_namespace
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "custom-metrics-apiserver"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "custom-metrics-apiserver"
          }
          "name" = "custom-metrics-apiserver"
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "--secure-port=6443",
                "--tls-cert-file=/var/run/serving-cert/serving.crt",
                "--tls-private-key-file=/var/run/serving-cert/serving.key",
                "--logtostderr=true",
                "--prometheus-url=http://scaling-prometheus.${var.scaling_prometheus_namespace}.svc.cluster.local:9090/",
                "--metrics-relist-interval=1m",
                "--v=6",
                "--config=/etc/adapter/config.yaml",
              ]
              "image" = "k8s.gcr.io/prometheus-adapter/prometheus-adapter:v0.9.0"
              "name" = "custom-metrics-apiserver"
              "ports" = [
                {
                  "containerPort" = 6443
                  "protocol" = "TCP"
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/var/run/serving-cert"
                  "name" = "volume-serving-cert"
                  "readOnly" = true
                },
                {
                  "mountPath" = "/etc/adapter/"
                  "name" = "config"
                  "readOnly" = true
                },
                {
                  "mountPath" = "/tmp"
                  "name" = "tmp-vol"
                },
              ]
            },
          ]
          "serviceAccountName" = "custom-metrics-apiserver"
          "volumes" = [
            {
              "name" = "volume-serving-cert"
              "secret" = {
                "secretName" = "custom-metrics-server"
                "items" = [
                  {
                    "key" = "tls.crt",
                    "path" = "serving.crt"
                  },
                  {
                    "key" = "tls.key",
                    "path" = "serving.key"
                  }
                ]
              }
            },
            {
              "configMap" = {
                "name" = "adapter-config"
              }
              "name" = "config"
            },
            {
              "emptyDir" = {}
              "name" = "tmp-vol"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_sn_system_custom_metrics_apiserver" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "custom-metrics-apiserver"
      "namespace" = var.metric_server_namespace
    }
    "spec" = {
      "ports" = [
        {
          "port" = 443
          "protocol" = "TCP"
          "targetPort" = 6443
        },
      ]
      "selector" = {
        "app" = "custom-metrics-apiserver"
      }
    }
  }
}

resource "kubernetes_manifest" "apiservice_v1beta1_custom_metrics_k8s_io" {
  manifest = {
    "apiVersion" = "apiregistration.k8s.io/v1beta1"
    "kind" = "APIService"
    "metadata" = {
      "name" = "v1beta1.custom.metrics.k8s.io"
    }
    "spec" = {
      "group" = "custom.metrics.k8s.io"
      "groupPriorityMinimum" = 100
      "insecureSkipTLSVerify" = true
      "service" = {
        "name" = "custom-metrics-apiserver"
        "namespace" = var.metric_server_namespace
      }
      "version" = "v1beta1"
      "versionPriority" = 100
    }
  }
}

resource "kubernetes_manifest" "apiservice_v1beta2_custom_metrics_k8s_io" {
  manifest = {
    "apiVersion" = "apiregistration.k8s.io/v1beta1"
    "kind" = "APIService"
    "metadata" = {
      "name" = "v1beta2.custom.metrics.k8s.io"
    }
    "spec" = {
      "group" = "custom.metrics.k8s.io"
      "groupPriorityMinimum" = 100
      "insecureSkipTLSVerify" = true
      "service" = {
        "name" = "custom-metrics-apiserver"
        "namespace" = var.metric_server_namespace
      }
      "version" = "v1beta2"
      "versionPriority" = 200
    }
  }
}

# https://github.com/kubernetes-sigs/prometheus-adapter/blob/master/docs/config.md
resource "kubernetes_manifest" "configmap_sn_system_adapter_config" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "config.yaml" = <<-EOT
      rules:
      - seriesQuery: 'container_cpu_usage_seconds_total{namespace!~"(sn-system|kube-system|olm|cert-manager)"}'
        seriesFilters: []
        resources:
          overrides:
            pod:
              resource: pod
            namespace:
              resource: namespace
        name:
          matches: 'container_cpu_usage_seconds_total'
          as: 'cpu_usage'
        metricsQuery: sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>}[5m])) by (<<.GroupBy>>) / (sum(container_spec_cpu_shares{<<.LabelMatchers>>}/1000) by (<<.GroupBy>>))  * 100
      - seriesQuery: 'container_network_receive_bytes_total{namespace!~"(sn-system|kube-system|olm|cert-manager)"}'
        seriesFilters: []
        resources:
          overrides:
            pod:
              resource: pod
            namespace:
              resource: namespace
        name:
          matches: 'container_network_receive_bytes_total'
          as: 'network_in_rate_kb'
        metricsQuery: rate(container_network_receive_bytes_total{<<.LabelMatchers>>}[5m]) / 1024
      - seriesQuery: 'container_network_transmit_bytes_total{namespace!~"(sn-system|kube-system|olm|cert-manager)"}'
        seriesFilters: []
        resources:
          overrides:
            pod:
              resource: pod
            namespace:
              resource: namespace
        name:
          matches: 'container_network_transmit_bytes_total'
          as: 'network_out_rate_kb'
        metricsQuery: rate(container_network_transmit_bytes_total{<<.LabelMatchers>>}[5m]) / 1024
      - seriesQuery: 'container_fs_reads_bytes_total{namespace!~"(sn-system|kube-system|olm|cert-manager)"}'
        seriesFilters: []
        resources:
          overrides:
            pod:
              resource: pod
            namespace:
              resource: namespace
        name:
          matches: 'container_fs_reads_bytes_total'
          as: 'disk_read_rate_kb'
        metricsQuery: sum(rate(container_fs_reads_bytes_total{<<.LabelMatchers>>}[5m])) by (<<.GroupBy>>) / 1024
      - seriesQuery: 'container_fs_writes_bytes_total{namespace!~"(sn-system|kube-system|olm|cert-manager)"}'
        seriesFilters: []
        resources:
          overrides:
            pod:
              resource: pod
            namespace:
              resource: namespace
        name:
          matches: 'container_fs_writes_bytes_total'
          as: 'disk_write_rate_kb'
        metricsQuery: sum(rate(container_fs_writes_bytes_total{<<.LabelMatchers>>}[5m])) by (<<.GroupBy>>) / 1024

      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name" = "adapter-config"
      "namespace" = var.metric_server_namespace
    }
  }
}
