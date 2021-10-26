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
      version = "2.2.0"
    }
  }
}

resource "helm_release" "istio_operator" {
  count           = var.enable_istio_operator ? 1 : 0
  atomic          = var.atomic
  chart           = var.istio_chart_name
  cleanup_on_fail = var.cleanup_on_fail
  name            = var.istio_release_name
  namespace       = var.istio_namespace
  timeout         = var.timeout
  repository      = var.istio_chart_repository
  version         = var.istio_chart_version

  values = [templatefile("${path.module}/values.yaml.tpl", {
    cluster_name    = var.cluster_name
    istio_namespace = var.istio_namespace
    mesh_id         = var.mesh_id
    revision_tag    = var.revision_tag
    trust_domain    = var.trust_domain
    })
  ]

  dynamic "set" {
    for_each = var.istio_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "kiali_operator" {
  count           = var.enable_kiali_operator ? 1 : 0
  atomic          = var.atomic
  chart           = var.kiali_chart_name
  cleanup_on_fail = var.cleanup_on_fail
  name            = var.kiali_release_name
  namespace       = var.kiali_namespace
  repository      = var.kiali_chart_repository
  timeout         = var.timeout
  version         = var.kiali_chart_version

  set {
    name  = "cr.create"
    value = "true"
  }
  set {
    name  = "cr.namespace"
    value = var.kiali_namespace
  }

  dynamic "set" {
    for_each = var.kiali_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
