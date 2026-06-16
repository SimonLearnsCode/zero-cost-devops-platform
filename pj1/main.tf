# Spin up the Kind Cluster with 1 Control Plane and 1 Worker Node
resource "kind_cluster" "dev_cluster" {
  name            = "devops-portfolio-cluster"
  kubeconfig_path = pathexpand("~/.kube/config")
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      
      # Map ports for local Ingress Controller access later
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }
  }
}

# Define local multi-tenant isolation via Namespaces
resource "kubernetes_namespace" "staging" {
  depends_on = [kind_cluster.dev_cluster]
  metadata {
    name = "staging"
    labels = {
      environment = "staging"
      tier        = "application"
    }
  }
}

resource "kubernetes_namespace" "production" {
  depends_on = [kind_cluster.dev_cluster]
  metadata {
    name = "production"
    labels = {
      environment = "production"
      tier        = "application"
    }
  }
}

# ConfigMap to point the cluster to a local insecure registry (running on port 5001)
resource "kubernetes_config_map" "local_registry" {
  depends_on = [kind_cluster.dev_cluster]
  metadata {
    name      = "local-registry-hosting"
    namespace = "kube-public"
  }

  data = {
    "localRegistryHosting.v1" = <<EOT
host: "localhost:5001"
help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOT
  }
}
