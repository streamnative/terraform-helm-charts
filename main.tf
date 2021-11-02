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
  cleanup_on_fail  = var.function_mesh_operator_cleanup_on_fail
  namespace        = var.function_mesh_operator_namespace
  release_name     = var.function_mesh_operator_release_name
  settings         = coalesce(var.function_mesh_operator_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  timeout          = var.function_mesh_operator_timeout
}

module "istio_operator" {
  count  = var.enable_istio_operator || var.enable_kiali_operator ? 1 : 0
  source = "./modules/istio-operator"

  cleanup_on_fail = var.istio_operator_cleanup_on_fail
  cluster_name    = var.istio_operator_cluster_name
  mesh_id         = var.istio_operator_mesh_id
  revision_tag    = var.istio_operator_revision_tag
  timeout         = var.istio_operator_timeout
  trust_domain    = var.istio_operator_trust_domain

  enable_istio_operator  = var.enable_istio_operator
  istio_chart_name       = var.istio_operator_chart_name
  istio_chart_repository = var.istio_operator_chart_repository
  istio_chart_version    = var.istio_operator_chart_version
  istio_namespace        = var.istio_operator_namespace
  istio_release_name     = var.istio_operator_release_name
  istio_settings         = coalesce(var.istio_operator_settings, {}) # The empty map is a placeholder value, reserved for future defaults

  enable_kiali_operator  = var.enable_kiali_operator
  kiali_chart_name       = var.kiali_operator_chart_name
  kiali_chart_repository = var.kiali_operator_chart_repository
  kiali_chart_version    = var.kiali_operator_chart_version
  kiali_namespace        = var.kiali_operator_namespace
  kiali_release_name     = var.kiali_operator_release_name
  kiali_settings         = coalesce(var.kiali_operator_settings, {}) # The empty map is a placeholder value, reserved for future defaults
}

module "olm" {
  count  = var.enable_olm ? 1 : 0
  source = "./modules/operator-lifecycle-manager"

  olm_namespace           = var.olm_namespace
  olm_operators_namespace = var.olm_operators_namespace
  settings                = coalesce(var.olm_settings, {}) # The empty map is a placeholder value, reserved for future defaults
}

module "olm_subscriptions" {
  count  = var.enable_olm ? 1 : 0
  source = "./modules/olm-subscriptions"

  catalog_namespace = var.olm_catalog_namespace
  namespace         = var.olm_namespace
  settings          = coalesce(var.olm_subscription_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  registry          = var.olm_registry

  depends_on = [
    module.olm
  ]
}

module "prometheus_operator" {
  count  = var.enable_prometheus_operator == true && var.enable_olm == false ? 1 : 0
  source = "./modules/prometheus-operator"

  chart_name       = var.prometheus_operator_chart_name
  chart_repository = var.prometheus_operator_chart_repository
  chart_version    = var.prometheus_operator_chart_version
  cleanup_on_fail  = var.prometheus_operator_cleanup_on_fail
  namespace        = var.prometheus_operator_namespace
  release_name     = var.prometheus_operator_release_name

  settings = coalesce(var.prometheus_operator_settings, { # Defaults are set to the right. Passing input via var.prometheus_operator_settings will override
    "alertmanager.enabled"     = "false"
    "grafana.enabled"          = "false"
    "kubeStateMetrics.enabled" = "false"
    "nodeExporter.enabled"     = "false"
    "prometheus.enabled"       = "false"
  })

  timeout = var.prometheus_operator_timeout
}

module "pulsar_operator" {
  count  = var.enable_pulsar_operator == true && var.enable_olm == false ? 1 : 0
  source = "./modules/pulsar-operator"

  chart_name       = var.pulsar_operator_chart_name
  chart_repository = var.pulsar_operator_chart_repository
  chart_version    = var.pulsar_operator_chart_version
  cleanup_on_fail  = var.pulsar_operator_cleanup_on_fail
  namespace        = var.pulsar_operator_namespace
  release_name     = var.pulsar_operator_release_name
  settings         = coalesce(var.pulsar_operator_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  timeout          = var.pulsar_operator_timeout
}

module "vault_operator" {
  count  = var.enable_vault_operator ? 1 : 0
  source = "./modules/vault-operator"

  chart_name       = var.vault_operator_chart_name
  chart_repository = var.vault_operator_chart_repository
  chart_version    = var.vault_operator_chart_version
  cleanup_on_fail  = var.vault_operator_cleanup_on_fail
  namespace        = var.vault_operator_namespace
  release_name     = var.vault_operator_release_name
  settings         = coalesce(var.vault_operator_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  timeout          = var.vault_operator_timeout
}

module "vector_agent" {
  count  = var.enable_vector_agent ? 1 : 0
  source = "./modules/vector-agent"

  chart_name       = var.vector_agent_chart_name
  chart_repository = var.vector_agent_chart_repository
  chart_version    = var.vector_agent_chart_version
  namespace        = var.vector_agent_namespace
  release_name     = var.vector_agent_release_name
  settings         = coalesce(var.vector_agent_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  timeout          = var.vector_agent_timeout
}

module "victoria_metrics" {
  count  = var.enable_victoria_metrics_stack || var.enable_victoria_metrics_auth ? 1 : 0
  source = "./modules/victoria-metrics"

  chart_repository = var.victoria_metrics_chart_repository
  timeout          = var.victoria_metrics_timeout

  enable_vmauth  = var.enable_victoria_metrics_auth
  enable_vmstack = var.enable_victoria_metrics_stack

  vmstack_chart_name    = var.victoria_metrics_stack_chart_name
  vmstack_chart_version = var.victoria_metrics_stack_chart_version
  vmstack_namespace     = var.victoria_metrics_stack_namespace
  vmstack_release_name  = var.victoria_metrics_stack_release_name
  vmstack_settings      = coalesce(var.victoria_metrics_stack_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  vmstack_values        = var.victoria_metrics_stack_values                 # The empty list is a placeholder value, reserved for future defaults

  vmauth_chart_name    = var.victoria_metrics_auth_chart_name
  vmauth_chart_version = var.victoria_metrics_auth_chart_version
  vmauth_namespace     = var.victoria_metrics_auth_namespace
  vmauth_release_name  = var.victoria_metrics_auth_release_name
  vmauth_settings      = coalesce(var.victoria_metrics_auth_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  vmauth_values        = var.victoria_metrics_auth_values                 # The empty list is a placeholder value, reserved for future defaults
}