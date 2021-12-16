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

  # VMStack Defaults
  create_vmstack_namespace = var.create_vmstack_namespace != null ? var.create_vmstack_namespace : true
  vmstack_chart_name       = var.vmstack_chart_name != null ? var.vmstack_chart_name : "victoria-metrics-k8s-stack"
  vmstack_chart_repository = var.vmstack_chart_repository != null ? var.vmstack_chart_repository : "https://victoriametrics.github.io/helm-charts/"
  vmstack_chart_version    = var.vmstack_chart_version != null ? var.vmstack_chart_version : "0.5.9"
  vmstack_namespace        = var.vmstack_namespace != null ? var.vmstack_namespace : "sn-system"
  vmstack_release_name     = var.vmstack_release_name != null ? var.vmstack_release_name : "vmstack"
  vmstack_settings         = var.vmstack_settings != null ? var.vmstack_settings : {}
  vmstack_values           = var.vmstack_values != null ? var.vmstack_values : []

  # VMAuth Defaults
  create_vmauth_namespace = var.create_vmauth_namespace != null ? var.create_vmauth_namespace : true
  vmauth_chart_name       = var.vmauth_chart_name != null ? var.vmauth_chart_name : "victoria-metrics-auth"
  vmauth_chart_repository = var.vmauth_chart_repository != null ? var.vmauth_chart_repository : "https://victoriametrics.github.io/helm-charts/"
  vmauth_chart_version    = var.vmauth_chart_version != null ? var.vmauth_chart_version : "0.2.33"
  vmauth_namespace        = var.vmauth_namespace != null ? var.vmauth_namespace : "sn-system"
  vmauth_release_name     = var.vmauth_release_name != null ? var.vmauth_release_name : "vmauth"
  vmauth_settings         = var.vmauth_settings != null ? var.vmauth_settings : {}
  vmauth_values           = var.vmauth_values != null ? var.vmauth_values : []

}

resource "helm_release" "victoria_metrics_stack" {
  count            = var.enable_vmstack ? 1 : 0
  atomic           = local.atomic
  chart            = local.vmstack_chart_name
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_vmstack_namespace
  name             = local.vmstack_release_name
  namespace        = local.vmstack_namespace
  repository       = local.vmstack_chart_repository
  timeout          = local.timeout
  version          = local.vmstack_chart_version
  values           = local.vmstack_values

  dynamic "set" {
    for_each = local.vmstack_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "victoria_metrics_vmauth" {
  count            = var.enable_vmauth ? 1 : 0
  atomic           = local.atomic
  chart            = local.vmauth_chart_name
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_vmauth_namespace
  name             = local.vmauth_release_name
  namespace        = local.vmauth_namespace
  repository       = local.vmauth_chart_repository
  timeout          = local.timeout
  version          = local.vmauth_chart_version
  values           = local.vmauth_values

  dynamic "set" {
    for_each = local.vmauth_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
