resource "kubernetes_deployment_v1" "test" {
  metadata {
    name = "test-deployment"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "test-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "test-app" # referenced in selector.match_labels and kubernetes_service_v1.test_lb.spec.selector.app
        }
      }
      spec {
        container {
          image = "nginxdemos/hello:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "test_lb" {
  metadata {
    name      = "test-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "test-app" # OR kubernetes_deployment_v1.test.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP" # or HTTP, HTTPS, GRPC, GRPCS, MONGO, REDIS, MYSQL
    }

    type = "LoadBalancer"
  }
}
/*
# we can also use kubernetes_manifest resource to create Kubernetes resources using YAML manifest file
resource "kubernetes_manifest" "test" {
  manifest = yamldecode(file("${path.module}/deployment.yaml"))
}
*/
