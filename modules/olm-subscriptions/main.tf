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
  atomic            = var.atomic != null ? var.atomic : true
  chart_name        = var.chart_name != null ? var.chart_name : "${path.module}/chart"
  chart_repository  = var.chart_repository != null ? var.chart_repository : null
  chart_version     = var.chart_version != null ? var.chart_version : null
  cleanup_on_fail   = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  install_namespace = var.install_namespace != null ? var.install_namespace : "sn-system"
  olm_namespace     = var.olm_namespace != null ? var.olm_namespace : "olm"
  release_name      = var.release_name != null ? var.release_name : "olm-subscriptions"
  settings          = var.settings != null ? var.settings : {}
  timeout           = var.timeout != null ? var.timeout : 120
  values            = var.values != null ? var.values : []
}


resource "helm_release" "olm_subscriptions" {
  atomic          = local.atomic
  chart           = local.chart_name
  cleanup_on_fail = local.cleanup_on_fail
  namespace       = local.olm_namespace
  name            = local.release_name
  repository      = local.chart_repository
  timeout         = local.timeout
  version         = local.chart_version
  values          = local.values

  set {
    name  = "olm_namespace"
    value = local.olm_namespace
    type  = "string"
  }

  set {
    name  = "install_namespace"
    value = local.install_namespace
    type  = "string"
  }

  set {
    name  = "sn_registry"
    value = var.registry
    type  = "string"
  }

  set {
    name  = "sn_operator_registry"
    value = var.sn_operator_registry
    type  = "string"
  }

  set {
    name  = "components.sn_operator"
    value = var.enable_sn_operator
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

resource "null_resource" "olm_registry_secret" {
  count = var.enable_sn_operator ? 1 : 0
  triggers = {
    olm_namespace = var.olm_namespace
    sn_operator_registry_username = var.sn_operator_registry_username
    sn_operator_registry_credential = var.sn_operator_registry_credential
  }
  provisioner "local-exec" {
    command = "kubectl create secret docker-registry cloudsmith-access -n ${var.olm_namespace} --docker-server=docker.cloudsmith.io --docker-username=${var.sn_operator_registry_username} --docker-password=${var.sn_operator_registry_credential}"
  }
  depends_on = [
    helm_release.olm_subscriptions
  ]
}

resource "null_resource" "patch_olm_sa" {
  count = var.enable_sn_operator ? 1 : 0
  triggers = {
    olm_namespace = var.olm_namespace
    sn_operator_catalog_sa = var.sn_operator_catalog_sa
  }
  provisioner "local-exec" {
    command = "kubectl patch serviceaccount ${var.sn_operator_catalog_sa} -n ${var.olm_namespace} -p '{\"imagePullSecrets\": [{\"name\": \"cloudsmith-access\"}]}'"
  }
  depends_on = [
    helm_release.olm_subscriptions,
    null_resource.olm_registry_secret
  ]
}

resource "null_resource" "controller_manager_registry_secret" {
  count = var.enable_sn_operator ? 1 : 0
  triggers = {
    install_namespace = var.install_namespace
    sn_operator_registry_username = var.sn_operator_registry_username
    sn_operator_registry_credential = var.sn_operator_registry_credential
  }
  provisioner "local-exec" {
    command = "kubectl create secret docker-registry cloudsmith-access -n ${var.install_namespace} --docker-server=docker.cloudsmith.io --docker-username=${var.sn_operator_registry_username} --docker-password=${var.sn_operator_registry_credential}"
  }
  depends_on = [
    helm_release.olm_subscriptions
  ]
}

resource "null_resource" "patch_controller_manager_sa" {
  count = var.enable_sn_operator ? 1 : 0
  triggers = {
    install_namespace = var.install_namespace
    sn_operator_controller_sa = var.sn_operator_controller_sa
  }
  provisioner "local-exec" {
    command = "kubectl patch serviceaccount ${var.sn_operator_controller_sa} -n ${var.install_namespace} -p '{\"imagePullSecrets\": [{\"name\": \"cloudsmith-access\"}]}'"
  }
  depends_on = [
    helm_release.olm_subscriptions,
    null_resource.controller_manager_registry_secret
  ]
}
