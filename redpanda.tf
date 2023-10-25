resource "kubernetes_namespace" "redpanda_system" {
  metadata {
    labels = {
      "name" = "redpanda-system"
    }
    name = "redpanda-system"
  }
}
resource "kubectl_manifest" "redpanda_crd" {
  yaml_body  = file("${path.module}/redpanda-crd.yaml")
  depends_on = [kubernetes_namespace.redpanda_system]
}
resource "helm_release" "redpanda" {
  name       = "redpanda-operator"
  chart      = "operator"
  repository = "https://charts.redpanda.com"
  namespace  = kubernetes_namespace.redpanda_system.metadata.0.name
  set {
    name  = "monitoring.enabled"
    value = "true"
    type  = "string"
  }
  depends_on = [helm_release.cert-manager, kubernetes_namespace.redpanda_system, kubectl_manifest.redpanda_crd]
}
