#cluster role
resource "kubernetes_cluster_role_v1" "eks_readonly_clusterrole" {
  depends_on = [time_sleep.wait_for_eks_access]
  metadata {
    name = "eks-readonly-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "pods", "services", "configmaps", "events", "namespaces"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list"]

  }
}

#cluster role binding
resource "kubernetes_cluster_role_binding_v1" "eks_readonly_clusterrolebinding" {

  metadata {
    name = "eks-readonly-cluster-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.eks_readonly_clusterrole.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "eks-readonly" # this is the name of the group
    api_group = "rbac.authorization.k8s.io"
  }
}
