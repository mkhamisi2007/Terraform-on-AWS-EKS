
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks_cluster.name
}
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}
resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [aws_eks_cluster.eks_cluster, time_sleep.wait_for_eks_access]
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

