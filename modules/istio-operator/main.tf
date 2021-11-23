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

terraform {
  required_version = ">=1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.2.0"
    }
  }
}

locals {
  atomic          = var.atomic != null ? var.atomic : true
  cleanup_on_fail = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  timeout         = var.timeout != null ? var.timeout : 120

  # Istio Operator Settings
  create_istio_system_namespace   = var.create_istio_system_namespace != null ? var.create_istio_system_namespace : true
  create_istio_operator_namespace = var.create_istio_operator_namespace != null ? var.create_istio_operator_namespace : true
  istio_chart_name                = var.istio_chart_name != null ? var.istio_chart_name : "istio-operator"
  istio_chart_repository          = var.istio_chart_repository != null ? var.istio_chart_repository : "https://stevehipwell.github.io/helm-charts/"
  istio_chart_version             = var.istio_chart_version != null ? var.istio_chart_version : "2.3.5"
  istio_cluster_name              = var.istio_cluster_name != null ? var.istio_cluster_name : null
  istio_mesh_id                   = var.istio_mesh_id != null ? var.istio_mesh_id : null
  istio_network                   = var.istio_network != null ? var.istio_network : "network1"
  istio_operator_namespace        = var.istio_operator_namespace != null ? var.istio_operator_namespace : "istio-operator"
  istio_profile                   = var.istio_profile != null ? var.istio_profile : "default"
  istio_release_name              = var.istio_release_name != null ? var.istio_release_name : "istio-operator"
  istio_revision_tag              = var.istio_revision_tag != null ? var.istio_revision_tag : "default"
  istio_settings                  = var.istio_settings != null ? var.istio_settings : {}
  istio_system_namespace          = var.istio_system_namespace != null ? var.istio_system_namespace : "istio-system"
  istio_trust_domain              = var.istio_trust_domain != null ? var.istio_trust_domain : "cluster.local"
  istio_values                    = var.istio_values != null ? var.istio_values : null

  # Kiali Operator Settings
  create_kiali_cr          = var.create_kiali_cr != null ? var.create_kiali_cr : true
  create_kiali_operator_namespace = var.create_kiali_operator_namespace != null ? var.create_kiali_operator_namespace : true
  kiali_chart_name         = var.kiali_chart_name != null ? var.kiali_chart_name : "kiali-operator"
  kiali_chart_repository   = var.kiali_chart_repository != null ? var.kiali_chart_repository : "https://kiali.org/helm-charts"
  kiali_chart_version      = var.kiali_chart_version != null ? var.kiali_chart_version : "1.43.0"
  kiali_namespace          = var.kiali_namespace != null ? var.kiali_namespace : "kiali"
  kiali_release_name       = var.kiali_release_name != null ? var.kiali_release_name : "kiali-operator"
  kiali_settings           = var.kiali_settings != null ? var.kiali_settings : {}
  kiali_operator_namespace = var.kiali_operator_namespace != null ? var.kiali_operator_namespace : "kiali-operator"
  kiali_values             = var.kiali_values != null ? var.kiali_values : []
}

resource "kubernetes_namespace" "istio_system" {
  count = local.create_istio_system_namespace ? 1 : 0
  metadata {
    name = local.istio_system_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }
}

resource "helm_release" "istio_operator" {
  count            = var.enable_istio_operator ? 1 : 0
  atomic           = local.atomic
  chart            = local.istio_chart_name
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_istio_operator_namespace
  name             = local.istio_release_name
  namespace        = local.istio_operator_namespace
  timeout          = local.timeout
  repository       = local.istio_chart_repository
  version          = local.istio_chart_version
  values = coalesce(local.istio_values, [templatefile("${path.module}/values.yaml.tpl", {
    cluster_name           = local.istio_cluster_name
    mesh_id                = local.istio_mesh_id
    network                = local.istio_network
    revision_tag           = local.istio_revision_tag
    istio_system_namespace = local.create_istio_system_namespace ? kubernetes_namespace.istio_system[0].metadata[0].name : local.istio_system_namespace
    profile                = local.istio_profile
    trust_domain           = local.istio_trust_domain
    })]
  )

  dynamic "set" {
    for_each = local.istio_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "kiali_operator" {
  count            = var.enable_kiali_operator ? 1 : 0
  atomic           = local.atomic
  chart            = local.kiali_chart_name
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_kiali_operator_namespace
  name             = local.kiali_release_name
  namespace        = local.kiali_operator_namespace
  repository       = local.kiali_chart_repository
  timeout          = local.timeout
  version          = local.kiali_chart_version

  set {
    name  = "cr.create"
    value = local.create_kiali_cr
  }
  set {
    name  = "cr.namespace"
    value = local.create_istio_system_namespace ? kubernetes_namespace.istio_system[0].metadata[0].name : local.kiali_namespace
  }

  dynamic "set" {
    for_each = local.kiali_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
