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
  cleanup_on_fail   = var.cleanup_on_fail != null ? var.cleanup_on_fail : true
  create_namespace  = var.create_namespace != null ? var.create_namespace : true
  chart_name        = var.chart_name != null ? var.chart_name : "victoria-metrics-agent"
  chart_repository  = var.chart_repository != null ? var.chart_repository : "https://victoriametrics.github.io/helm-charts/"
  chart_version     = var.chart_version != null ? var.chart_version : "0.7.42"
  namespace         = var.namespace != null ? var.namespace : "sn-system"
  release_name      = var.release_name != null ? var.release_name : "vmagent"
  remote_write_urls = var.remote_write_urls != null ? var.remote_write_urls : []
  settings          = var.settings != null ? var.settings : {}
  timeout           = var.timeout != null ? var.timeout : 120
  values            = var.values != null ? var.values : []

  basicauth_enabled         = var.basicauth_enabled != null ? var.basicauth_enabled : false
  basicauth_password        = var.basicauth_password != null ? var.basicauth_password : ""
  gsa_audience              = var.gsa_audience != null ? var.gsa_audience : ""
  basicauth_username        = var.basicauth_username != null ? var.basicauth_username : ""
  oauth2_enabled            = var.oauth2_enabled != null ? var.oauth2_enabled : false
  oauth2_client_id          = var.oauth2_client_id != null ? var.oauth2_client_id : ""
  oauth2_client_secret      = var.oauth2_client_secret != null ? var.oauth2_client_secret : ""
  oauth2_token_url          = var.oauth2_token_url != null ? var.oauth2_token_url : ""
  pods_scrape_namespaces    = var.pods_scrape_namespaces != null ? var.pods_scrape_namespaces : ["sn-system"]
}

resource "helm_release" "vmagent" {
  atomic           = local.atomic
  chart            = local.chart_name
  cleanup_on_fail  = local.cleanup_on_fail
  create_namespace = local.create_namespace
  name             = local.release_name
  namespace        = local.namespace
  repository       = local.chart_repository
  timeout          = local.timeout
  version          = local.chart_version

  values = coalescelist(local.values, [templatefile("${path.module}/values.yaml.tftpl", {
    basicauth_enabled         = local.basicauth_enabled
    basicauth_password        = base64decode(local.basicauth_password)
    basicauth_username        = local.basicauth_username
    gsa_audience              = local.gsa_audience
    oauth2_enabled            = local.oauth2_enabled
    oauth2_client_id          = local.oauth2_client_id
    oauth2_client_secret      = base64decode(local.oauth2_client_secret)
    oauth2_token_url          = local.oauth2_token_url
    pods_scrape_namespaces    = local.pods_scrape_namespaces
    remote_write_urls         = local.remote_write_urls
  })])

  dynamic "set" {
    for_each = local.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
