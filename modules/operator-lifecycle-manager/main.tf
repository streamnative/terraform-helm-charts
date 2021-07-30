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

# Note: This module is opinionated about how it manages namespaces, and is specific to the needs of StreamNative.

terraform {
  required_version = ">=1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
  }
}

resource "kubernetes_namespace" "olm" {
  metadata {
    name = var.olm_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }
}

resource "kubernetes_namespace" "operators" {
  metadata {
    name = var.olm_operators_namespace
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }
}

resource "helm_release" "operator_lifecycle_manager" {
  atomic          = var.atomic
  chart           = var.chart_repository != "" ? var.chart_repository : "${path.module}/chart"
  cleanup_on_fail = var.cleanup_on_fail
  name            = var.release_name
  namespace       = kubernetes_namespace.olm.id
  timeout         = var.timeout

  set {
    name  = "namespace"
    value = kubernetes_namespace.olm.id
    type  = "string"
  }

  set {
    name  = "catalog_namespace"
    value = kubernetes_namespace.olm.id
    type  = "string"
  }

  set {
    name  = "operator_namespace"
    value = kubernetes_namespace.operators.id
    type  = "string"
  }

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
