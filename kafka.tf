resource "kubernetes_namespace" "kafka" {
  metadata {
    labels = {
      "name" = "kafka"
    }
    name = "kafka"
  }
}
resource "helm_release" "kafka" {
  name       = "kafka"
  chart      = "strimzi-kafka-operator"
  repository = "https://strimzi.io/charts/"
  version    = "0.38.0"
  namespace  = kubernetes_namespace.kafka.metadata.0.name
  set {
    name  = "watchNamespaces"
    value = "{default}"
  }
  depends_on = [
    kubernetes_namespace.kafka, helm_release.cert-manager
  ]
}
resource "kubernetes_manifest" "kafka-persistent-single" {
  manifest = {
    "apiVersion" = "kafka.strimzi.io/v1beta2"
    "kind"       = "Kafka"
    "metadata" = {
      "name"      = "data-cluster"
      "namespace" = "kafka"
    }
    "spec" = {
      "entityOperator" = {
        "topicOperator" = {}
        "userOperator"  = {}
      }
      "kafka" = {
        "config" = {
          "default.replication.factor"               = 1
          "inter.broker.protocol.version"            = "3.6"
          "min.insync.replicas"                      = 1
          "offsets.topic.replication.factor"         = 1
          "transaction.state.log.min.isr"            = 1
          "transaction.state.log.replication.factor" = 1
        }
        "listeners" = [
          {
            "name" = "plain"
            "port" = 9092
            "tls"  = false
            "type" = "internal"
          },
          {
            "name" = "tls"
            "port" = 9093
            "tls"  = true
            "type" = "internal"
          },
        ]
        "replicas" = 1
        "storage" = {
          "type" = "jbod"
          "volumes" = [
            {
              "deleteClaim" = false
              "id"          = 0
              "size"        = "100Gi"
              "type"        = "persistent-claim"
            },
          ]
        }
        "version" = "3.6.0"
      }
      "zookeeper" = {
        "replicas" = 1
        "storage" = {
          "deleteClaim" = false
          "size"        = "100Gi"
          "type"        = "persistent-claim"
        }
      }
    }
  }
}
