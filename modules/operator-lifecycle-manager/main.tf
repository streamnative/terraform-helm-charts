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
      version = ">=2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.6.1"
    }
  }
}

locals {
  atomic                   = var.atomic != null ? var.atomic : true
  chart_name               = var.chart_name != null ? var.chart_name : ""
  chart_repository         = var.chart_repository != null ? var.chart_repository : "${path.module}/chart"
  chart_version            = var.chart_version != null ? var.chart_version : ""
  cleanup_on_fail          = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  create_install_namespace = var.create_install_namespace != null ? var.create_install_namespace : true
  create_olm_namespace     = var.create_olm_namespace != null ? var.create_olm_namespace : true
  install_namespace        = var.install_namespace != null ? var.install_namespace : "operators"
  olm_namespace            = var.olm_namespace != null ? var.olm_namespace : "olm"
  release_name             = var.release_name != null ? var.release_name : "operator-lifecycle-manager"
  settings                 = var.settings != null ? var.settings : {}
  timeout                  = var.timeout != null ? var.timeout : 120
  values                   = var.values != null ? var.values : []
  image_registry           = var.image_registry != null ? var.image_registry : "quay.io"
  image_repository         = var.image_repository != null ? var.image_repository : "operator-framework"
  image_name               = var.image_name != null ? var.image_name : "olm"
  image_tag                = var.image_tag != null ? var.image_tag : "v0.20.0"
}

resource "kubernetes_namespace" "olm_install" {
  count = local.create_install_namespace ? 1 : 0
  metadata {
    name = local.install_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels
    ]
  }
}

resource "helm_release" "operator_lifecycle_manager" {
  atomic           = local.atomic
  chart            = local.chart_repository
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_olm_namespace
  name             = local.release_name
  namespace        = local.olm_namespace
  timeout          = local.timeout
  values           = local.values
  version          = local.chart_version

  set {
    name  = "namespace"
    value = local.olm_namespace
    type  = "string"
  }

  set {
    name  = "catalog_namespace"
    value = local.olm_namespace
    type  = "string"
  }

  set {
    name  = "operator_namespace"
    value = local.create_install_namespace ? kubernetes_namespace.olm_install[0].id : local.install_namespace
    type  = "string"
  }

  set {
    name  = "image.registry"
    value = local.image_registry
    type  = "string"
  }

  set {
    name  = "image.repository"
    value = local.image_repository
    type  = "string"
  }

  set {
    name  = "image.name"
    value = local.image_name
    type  = "string"
  }
  set {
    name  = "image.tag"
    value = local.image_tag
    type  = "string"
  }


  dynamic "set" {
    for_each = local.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
