resource "kubernetes_namespace" "dask" {
  metadata {
    labels = {
      "name" = "dask"
    }
    name = "dask"
  }
}
resource "helm_release" "dask" {
  name       = "dask"
  chart      = "dask-kubernetes-operator"
  repository = "https://helm.dask.org"
  version    = "0.38.0"
  namespace  = kubernetes_namespace.dask.metadata.0.name
  depends_on = [
    kubernetes_namespace.dask, helm_release.cert-manager
  ]
}
