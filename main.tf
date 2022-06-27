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

module "function_mesh_operator" {
  count  = var.enable_function_mesh_operator == true && var.enable_olm == false ? 1 : 0
  source = "./modules/function-mesh-operator"

  chart_name       = var.function_mesh_operator_chart_name
  chart_repository = var.function_mesh_operator_chart_repository
  chart_version    = var.function_mesh_operator_chart_version
  create_namespace = var.create_function_mesh_operator_namespace
  namespace        = var.function_mesh_operator_namespace
  release_name     = var.function_mesh_operator_release_name
  settings         = var.function_mesh_operator_settings
  timeout          = var.function_mesh_operator_timeout
  values           = var.function_mesh_operator_values
}

module "istio_operator" {
  count  = var.enable_istio_operator || var.enable_kiali_operator ? 1 : 0
  source = "./modules/istio-operator"

  create_istio_system_namespace   = var.create_istio_system_namespace
  create_istio_operator_namespace = var.create_istio_operator_namespace
  create_kiali_cr                 = var.create_kiali_cr
  create_kiali_operator_namespace = var.create_kiali_operator_namespace
  enable_istio_operator           = var.enable_istio_operator
  enable_kiali_operator           = var.enable_kiali_operator
  istio_chart_name                = var.istio_operator_chart_name
  istio_chart_repository          = var.istio_operator_chart_repository
  istio_chart_version             = var.istio_operator_chart_version
  istio_cluster_name              = var.istio_cluster_name
  istio_mesh_id                   = var.istio_mesh_id
  istio_network                   = var.istio_network
  istio_operator_namespace        = var.istio_operator_namespace
  istio_profile                   = var.istio_profile
  istio_release_name              = var.istio_operator_release_name
  istio_revision_tag              = var.istio_revision_tag
  istio_settings                  = var.istio_operator_settings
  istio_system_namespace          = var.istio_system_namespace
  istio_trust_domain              = var.istio_trust_domain
  istio_gateway_certificate_name  = "istio-ingressgateway-tls"
  istio_gateway_certificate_hosts = ["*.${var.service_domain}"]
  istio_gateway_certificate_issuer = {
    group = "cert-manager.io"
    kind  = "ClusterIssuer"
    name  = "external"
  }
  istio_values = var.istio_operator_values

  kiali_operator_chart_name       = var.kiali_operator_chart_name
  kiali_operator_chart_repository = var.kiali_operator_chart_repository
  kiali_operator_chart_version    = var.kiali_operator_chart_version
  kiali_operator_release_name     = var.kiali_operator_release_name
  kiali_operator_namespace        = var.kiali_operator_namespace
  kiali_operator_settings         = var.kiali_operator_settings
  kiali_operator_values           = var.kiali_operator_values
  kiali_namespace                 = var.kiali_namespace
  kiali_gateway_hosts             = ["kiali.${var.service_domain}"]
  kiali_gateway_tls_secret        = "istio-ingressgateway-tls"
  timeout                         = var.istio_operator_timeout
}

module "olm" {
  count  = var.enable_olm ? 1 : 0
  source = "./modules/operator-lifecycle-manager"

  create_install_namespace = var.create_olm_install_namespace
  create_olm_namespace     = var.create_olm_namespace
  install_namespace        = var.olm_install_namespace
  olm_namespace            = var.olm_namespace
  settings                 = var.olm_settings
  values                   = var.olm_values
}

module "olm_subscriptions" {
  count  = var.enable_olm ? 1 : 0
  source = "./modules/olm-subscriptions"

  olm_namespace          = var.olm_namespace
  install_namespace      = var.olm_install_namespace
  enable_istio           = var.olm_enable_istio
  istio_system_namespace = var.olm_istio_system_namespace
  settings               = var.olm_subscription_settings
  registry               = var.olm_registry
  values                 = var.olm_subscription_values

  depends_on = [
    module.olm
  ]
}

module "otel_collector" {
  count  = var.enable_otel_collector ? 1 : 0
  source = "./modules/otel-collector"

  chart_name       = var.otel_collector_chart_name
  chart_repository = var.otel_collector_chart_repository
  chart_version    = var.otel_collector_chart_version
  create_namespace = var.create_otel_collector_namespace
  namespace        = var.otel_collector_namespace
  image_version    = var.otel_collector_image_version
  release_name     = var.otel_collector_release_name
  settings         = var.otel_collector_settings
  timeout          = var.otel_collector_timeout
  values           = var.otel_collector_values
}

module "cloud-manager-agent" {
  count  = var.enable_cma ? 1 : 0
  source = "./modules/cloud-manager-agent"

  namespace   = var.cma_namespace
  settings    = var.cma_settings
  environment = var.cma_environment
  values      = var.cma_values
}

locals {
  prometheus_operator_values = var.prometheus_operator_values != null ? var.prometheus_operator_values : [yamlencode({
    grafana = {
      enabled = false
    }
    prometheus = {
      enabled = false
    }
  })]
}

module "prometheus_operator" {
  count  = var.enable_prometheus_operator == true ? 1 : 0
  source = "./modules/prometheus-operator"

  chart_name           = var.prometheus_operator_chart_name
  chart_repository     = var.prometheus_operator_chart_repository
  chart_version        = var.prometheus_operator_chart_version
  create_namespace     = var.create_prometheus_operator_namespace
  install_cluster_role = var.install_prometheus_cluster_role
  namespace            = var.prometheus_operator_namespace
  release_name         = var.prometheus_operator_release_name
  settings             = var.prometheus_operator_settings
  timeout              = var.prometheus_operator_timeout
  values               = local.prometheus_operator_values
}

module "pulsar_operator" {
  count  = var.enable_pulsar_operator == true && var.enable_olm == false ? 1 : 0
  source = "./modules/pulsar-operator"

  chart_name       = var.pulsar_operator_chart_name
  chart_repository = var.pulsar_operator_chart_repository
  chart_version    = var.pulsar_operator_chart_version
  create_namespace = var.create_pulsar_operator_namespace
  namespace        = var.pulsar_operator_namespace
  release_name     = var.pulsar_operator_release_name
  settings         = var.pulsar_operator_settings
  timeout          = var.pulsar_operator_timeout
  values           = var.pulsar_operator_values
}

module "vault_operator" {
  count  = var.enable_vault_operator ? 1 : 0
  source = "./modules/vault-operator"

  chart_name       = var.vault_operator_chart_name
  chart_repository = var.vault_operator_chart_repository
  chart_version    = var.vault_operator_chart_version
  create_namespace = var.create_vault_operator_namespace
  namespace        = var.vault_operator_namespace
  release_name     = var.vault_operator_release_name
  settings         = var.vault_operator_settings
  timeout          = var.vault_operator_timeout
  values           = var.vault_operator_values
}

module "vector_agent" {
  count  = var.enable_vector_agent ? 1 : 0
  source = "./modules/vector-agent"

  chart_name                 = var.vector_agent_chart_name
  chart_repository           = var.vector_agent_chart_repository
  chart_version              = var.vector_agent_chart_version
  create_namespace           = var.create_vector_agent_namespace
  namespace                  = var.vector_agent_namespace
  release_name               = var.vector_agent_release_name
  settings                   = var.vector_agent_settings
  sink_endpoint              = var.vector_sink_endpoint
  sink_name                  = var.vector_sink_name
  sink_oauth_audience        = var.vector_sink_oauth_audience
  sink_oauth_credentials_url = var.vector_sink_oauth_credentials_url
  sink_oauth_issuer_url      = var.vector_sink_oauth_issuer_url
  sink_topic                 = var.vector_sink_topic
  timeout                    = var.vector_agent_timeout
  values                     = var.vector_agent_values
}

module "vmagent" {
  count  = var.enable_vmagent ? 1 : 0
  source = "./modules/victoria-metrics-agent"

  basicauth_enabled      = var.vmagent_basicauth_enabled
  basicauth_username     = var.vmagent_basicauth_username
  basicauth_password     = var.vmagent_basicauth_password
  gsa_audience           = var.vmagent_gsa_audience
  gtoken_image           = var.vmagent_gtoken_image
  gtoken_image_version   = var.vmagent_gtoken_image_version
  chart_name             = var.vmagent_chart_name
  chart_repository       = var.vmagent_chart_repository
  chart_version          = var.vmagent_chart_version
  create_namespace       = var.create_vmagent_namespace
  namespace              = var.vmagent_namespace
  oauth2_enabled         = var.vmagent_oauth2_enabled
  oauth2_client_id       = var.vmagent_oauth2_client_id
  oauth2_client_secret   = var.vmagent_oauth2_client_secret
  oauth2_token_url       = var.vmagent_oauth2_token_url
  release_name           = var.vmagent_release_name
  remote_write_urls      = var.vmagent_remote_write_urls
  settings               = var.vmagent_settings
  pods_scrape_namespaces = var.vmagent_pods_scrape_namespaces
  timeout                = var.vmagent_timeout
  values                 = var.vmagent_values
}
