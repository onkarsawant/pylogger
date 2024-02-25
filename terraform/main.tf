# main.tf

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "development" {
  metadata {
    name = "byterraform"
  }
}

resource "kubernetes_config_map" "pylogger-cm" {
  metadata {
    name      = "pylogger-cm"
    namespace = kubernetes_namespace.development.metadata.0.name
  }

  data = {
    environment = "development"
    release     = "stable"
  }
}

resource "kubernetes_deployment" "pylogger" {
  metadata {
    name      = "pylogger"
    namespace = kubernetes_namespace.development.metadata[0].name
    labels = {
      app = "pylogger"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pylogger"
      }
    }

    template {
      metadata {
        labels = {
          app = "pylogger"
        }
      }
      spec {
        container {
          name  = "pylogger"
          image = "docker.io/onkarsawant/pylogger"

          env {
            name  = "cluster"
            value = "local"
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.pylogger-cm.metadata.0.name
            }
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "pylogger" {
  metadata {
    name      = "pylogger-service"
    namespace = kubernetes_namespace.development.metadata.0.name
  }

  spec {
    selector = {
      app = kubernetes_deployment.pylogger.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "ClusterIP"
  }
}