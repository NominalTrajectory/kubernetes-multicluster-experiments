provider "kubernetes" {
  host                   = var.host
  client_certificate     = var.client_certificate
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_deployment" "test_deployment" {
  metadata {
    name = "kubernetes-multicluster-experiments-deployment"
    labels = {
      app = "kubernetes-multicluster-experiments"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "kubernetes-multicluster-experiments"
      }
    }

    template {
      metadata {
        labels = {
          app = "kubernetes-multicluster-experiments"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "test-nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/nginx_status"
              port = "80"

              http_header {
                name  = "X-Custom-Header"
                value = "kubernetes-multicluster-experiments"
              }
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }

        }
      }

    }
  }
}


resource "kubernetes_service" "kubernetes-multicluster-experiments-service" {
  metadata {
    name = "kubernetes-multicluster-experiments-service"
  }

  spec {
    selector = {
      app = "kubernetes-multicluster-experiments"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
