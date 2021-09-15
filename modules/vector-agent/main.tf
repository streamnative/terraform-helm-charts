resource "helm_release" "vector_agent" {
  atomic           = var.atomic
  chart            = var.chart_name
  cleanup_on_fail  = var.cleanup_on_fail
  create_namespace = var.create_namespace
  name             = var.release_name
  namespace        = var.namespace
  repository       = var.chart_repository
  timeout          = var.timeout
  version          = var.chart_version
  values           = var.values

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}