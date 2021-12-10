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

resource "helm_release" "olm_subscriptions" {
  atomic          = var.atomic
  chart           = "${path.module}/chart"
  cleanup_on_fail = var.cleanup_on_fail
  namespace       = var.namespace
  name            = var.release_name
  timeout         = var.timeout

  set {
    name  = "catalog_namespace"
    value = var.catalog_namespace
    type  = "string"
  }

  set {
    name  = "install_namespace"
    value = var.namespace
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
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "null_resource" "olm_cloudsmith_secret" {
  count = var.enable_sn_operator ? 1 : 0
  triggers = {
    namespace = var.namespace
    sn_operator_registry_username = var.sn_operator_registry_username
    sn_operator_registry_credential = var.sn_operator_registry_credential
  }
  provisioner "local-exec" {
    command = "kubectl create secret docker-registry cloudsmith-access -n ${var.namespace} --docker-server=docker.cloudsmith.io --docker-username=${var.sn_operator_registry_username} --docker-password=${var.sn_operator_registry_credential}"
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
    null_resource.olm_cloudsmith_secret
  ]
}

resource "null_resource" "controller_manager_cloudsmith_secret" {
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

resource "null_resource" "patch_controllermanager__sa" {
  count = var.enable_sn_operator ? 1 : 0
  triggers = {
    namespace = var.namespace
    sn_operator_controller_sa = var.sn_operator_controller_sa
  }
  provisioner "local-exec" {
    command = "kubectl patch serviceaccount ${var.sn_operator_controller_sa} -n ${var.namespace} -p '{\"imagePullSecrets\": [{\"name\": \"cloudsmith-access\"}]}'"
  }
  depends_on = [
    helm_release.olm_subscriptions,
    null_resource.manager_cloudsmith_secret
  ]
}
