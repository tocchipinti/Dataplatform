resource "kubernetes_namespace" "airflow" {
  metadata {
    labels = {
      "name" = "airflow"
    }
    name = "airflow"
  }
}
resource "helm_release" "airflow" {
  name       = "apache-airflow"
  chart      = "airflow"
  repository = "https://airflow.apache.org"
  version    = "1.11.0"
  namespace  = kubernetes_namespace.airflow.metadata.0.name
  depends_on = [
    kubernetes_namespace.airflow, helm_release.cert-manager
  ]
}
