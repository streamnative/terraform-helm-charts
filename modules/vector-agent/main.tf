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
  atomic                     = var.atomic != null ? var.atomic : true
  chart_name                 = var.chart_name != null ? var.chart_name : "vector-agent"
  chart_repository           = var.chart_repository != null ? var.chart_repository : "https://helm.vector.dev"
  chart_version              = var.chart_version != null ? var.chart_version : "0.21.3"
  cleanup_on_fail            = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  create_namespace           = var.create_namespace != null ? var.create_namespace : true
  namespace                  = var.namespace != null ? var.namespace : "sn-system"
  release_name               = var.release_name != null ? var.release_name : "vector-agent"
  settings                   = var.settings != null ? var.settings : {}
  sink_endpoint              = var.sink_endpoint != null ? var.sink_endpoint : ""
  sink_name                  = var.sink_name != null ? var.sink_name : "sn-default"
  sink_topic                 = var.sink_topic != null ? var.sink_topic : ""
  sink_oauth_audience        = var.sink_oauth_audience != null ? var.sink_oauth_audience : ""
  sink_oauth_credentials_url = var.sink_oauth_credentials_url != null ? var.sink_oauth_credentials_url : ""
  sink_oauth_issuer_url      = var.sink_oauth_issuer_url != null ? var.sink_oauth_issuer_url : ""
  timeout                    = var.timeout != null ? var.timeout : 120
  values                     = var.values != null ? var.values : []
}

resource "helm_release" "vector_agent" {
  atomic          = local.atomic
  chart           = local.chart_name
  cleanup_on_fail = local.cleanup_on_fail
  name            = local.release_name
  namespace       = local.namespace
  repository      = local.chart_repository
  timeout         = local.timeout
  version         = local.chart_version

  values = coalescelist(local.values, [templatefile("${path.module}/values.yaml.tftpl", {
    sink_name                  = local.sink_name
    sink_endpoint              = local.sink_endpoint
    sink_oauth_audience        = local.sink_oauth_audience
    sink_oauth_credentials_url = base64decode(local.sink_oauth_credentials_url)
    sink_oauth_issuer_url      = local.sink_oauth_issuer_url
    sink_topic                 = local.sink_topic
    })]
  )

  dynamic "set" {
    for_each = local.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}