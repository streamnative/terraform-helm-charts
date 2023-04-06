# Copyright 2023 StreamNative, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
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
  atomic           = var.atomic != null ? var.atomic : true
  chart_name       = var.chart_name != null ? var.chart_name : "pulsar-operator"
  chart_repository = var.chart_repository != null ? var.chart_repository : "https://charts.streamnative.io"
  chart_version    = var.chart_version != null ? var.chart_version : "0.8.17"
  cleanup_on_fail  = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  create_namespace = var.create_namespace != null ? var.create_namespace : true
  namespace        = var.namespace != null ? var.namespace : "sn-system"
  release_name     = var.release_name != null ? var.release_name : "pulsar-operator"
  settings         = var.settings != null ? var.settings : {}
  timeout          = var.timeout != null ? var.timeout : 120
  values           = var.values != null ? var.values : []
}

resource "helm_release" "pulsar_operator" {
  atomic           = local.atomic
  chart            = local.chart_name
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_namespace
  namespace        = local.namespace
  name             = local.release_name
  repository       = local.chart_repository
  timeout          = local.timeout
  version          = local.chart_version
  values           = local.values

  dynamic "set" {
    for_each = local.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
