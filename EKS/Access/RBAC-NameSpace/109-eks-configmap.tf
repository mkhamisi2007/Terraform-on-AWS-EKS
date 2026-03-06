
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks_cluster.name
}
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}
resource "kubernetes_config_map_v1" "aws_auth" {
  /* depends_on = [
    aws_eks_cluster.eks_cluster,
    time_sleep.wait_for_eks_access,
    kubernetes_cluster_role_binding_v1.eks_readonly_clusterrolebinding
  ]*/
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_nodegroup_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      },
      {
        rolearn  = aws_iam_role.eks_admin_role.arn # for role group access(201, 202)
        username = "eks-admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = aws_iam_role.eks_readonly_role.arn                                                   # for role group access(301, 302)
        username = "eks-readonly"                                                                       # any name
        groups   = [kubernetes_cluster_role_binding_v1.eks_readonly_clusterrolebinding.subject[0].name] # this is the name of the cluster role created in 303-rbac.tf
      },
      {
        rolearn  = aws_iam_role.eks_readonly_role.arn                              # for role group access(401)
        username = "eks-fullaccess"                                                # any name
        groups   = [kubernetes_role_binding_v1.fullaccess_binding.subject[0].name] # this is the name of the role created in 401-rbac.tf
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = aws_iam_user.admin_user.arn
        username = aws_iam_user.admin_user.name
        groups   = ["system:masters"]
      },
      {
        userarn  = aws_iam_user.basic_user.arn
        username = aws_iam_user.basic_user.name
        groups   = ["system:masters"]
      }
    ])
  }
}

