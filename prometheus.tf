# resource "null_resource" "prometheus-operator" {
#   provisioner "local-exec" {
#     command = "kubectl create -f ${path.module}/prometheus-operator.yaml"
#   }
# }
