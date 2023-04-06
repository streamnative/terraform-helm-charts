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
  chart_name       = var.chart_name != null ? var.chart_name : "${path.module}/chart"
  chart_repository = var.chart_repository != null ? var.chart_repository : null
  chart_version    = var.chart_version != null ? var.chart_version : null
  cleanup_on_fail  = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  namespace        = var.namespace != null ? var.namespace : "sn-system"
  release_name     = var.release_name != null ? var.release_name : "cloud-manager-agent"
  settings         = var.settings != null ? var.settings : {}
  timeout          = var.timeout != null ? var.timeout : 120
  values           = var.values != null ? var.values : []
  environment      = var.environment != null ? var.environment : "production"
}

resource "helm_release" "cloud-manager-agent" {
  atomic          = local.atomic
  chart           = local.chart_name
  cleanup_on_fail = local.cleanup_on_fail
  namespace       = local.namespace
  name            = local.release_name
  repository      = local.chart_repository
  timeout         = local.timeout
  version         = local.chart_version

  values = coalescelist(local.values, [templatefile("${path.module}/values.yaml.tftpl", {
    environment = local.environment
  })])

  dynamic "set" {
    for_each = local.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
