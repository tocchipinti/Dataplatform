resource "kubectl_manifest" "prometheus-operator" {
  yaml_body = file("${path.module}/prometheus-operator.yaml")
}
