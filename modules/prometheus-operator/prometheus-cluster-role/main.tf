resource "helm_release" "prometheus_cluster_role" {
  atomic          = true
  chart           = "${path.module}/chart"
  cleanup_on_fail = true
  namespace       = "kube-system"
  timeout         = 120
  name            = "prometheus-cluster-role"
}
