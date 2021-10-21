terraform {
  required_version = ">=1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

resource "helm_release" "victoria_metrics_stack" {
  count            = var.enable_vmstack ? 1 : 0
  atomic           = var.atomic
  chart            = var.vmstack_chart_name
  cleanup_on_fail  = var.cleanup_on_fail
  create_namespace = var.vmstack_create_namespace
  name             = var.vmstack_release_name
  namespace        = var.vmstack_namespace
  repository       = var.chart_repository
  timeout          = var.timeout
  version          = var.vmstack_chart_version
  values           = var.vmstack_values

  dynamic "set" {
    for_each = var.vmstack_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "victoria_metrics_vmauth" {
  count            = var.enable_vmauth ? 1 : 0
  atomic           = var.atomic
  chart            = var.vmauth_chart_name
  cleanup_on_fail  = var.cleanup_on_fail
  create_namespace = var.vmauth_create_namespace
  name             = var.vmauth_release_name
  namespace        = var.vmauth_namespace
  repository       = var.chart_repository
  timeout          = var.timeout
  version          = var.vmauth_chart_version
  values           = var.vmauth_values

  dynamic "set" {
    for_each = var.vmauth_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
