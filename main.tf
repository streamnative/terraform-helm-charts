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
  count  = var.enable_istio_operator ? 1 : 0
  source = "./modules/istio-operator"

  cleanup_on_fail = var.istio_operator_cleanup_on_fail
  namespace       = var.istio_operator_namespace
  release_name    = var.istio_operator_release_name
  settings        = coalesce(var.istio_operator_settings, {}) # The empty map is a placeholder value, reserved for future defaults
  timeout         = var.istio_operator_timeout
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
  values           = coalesce(var.vector_agent_values, []) # The empty list is a placeholder value, reserved for future defaults
}