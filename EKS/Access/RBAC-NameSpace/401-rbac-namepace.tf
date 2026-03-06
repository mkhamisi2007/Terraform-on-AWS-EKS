resource "kubernetes_namespace_v1" "dev_namespace" {
  depends_on = [time_sleep.wait_for_eks_access]
  metadata {
    name = "dev"
  }
}

resource "kubernetes_role_v1" "fullaccess_role" {
  metadata {
    name      = "fullaccess-role"
    namespace = kubernetes_namespace_v1.dev_namespace.metadata[0].name
  }

  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["*"]

  }

}

resource "kubernetes_role_binding_v1" "fullaccess_binding" {
  metadata {
    name      = "fullaccess-binding"
    namespace = kubernetes_namespace_v1.dev_namespace.metadata[0].name
  }
  role_ref {
    kind      = "Role"
    name      = kubernetes_role_v1.fullaccess_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = "dev-user"
    api_group = "rbac.authorization.k8s.io"
  }
}
