data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks_cluster.name
}
provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Install Cluster Autoscaler using HELM

# Resource: Helm Release 
resource "helm_release" "cluster_autoscaler_release" {
  depends_on = [aws_iam_role.cluster_autoscaler_iam_role, time_sleep.wait_for_eks_access]
  name       = "ca"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  namespace = "kube-system"

  set = [
    {
      name  = "cloudProvider"
      value = "aws"
    },
    {
      name  = "autoDiscovery.clusterName"
      value = aws_eks_cluster.eks_cluster.name
    },
    {
      name  = "awsRegion"
      value = var.aws_region
    },
    {
      name  = "rbac.serviceAccount.create"
      value = "true"
    },
    {
      name  = "rbac.serviceAccount.name"
      value = "cluster-autoscaler" # refer to ServiceAccount in file 201 line 49
    },
    {
      name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.cluster_autoscaler_iam_role.arn
    }
    # Additional Arguments (Optional) - To Test How to pass Extra Args for Cluster Autoscaler
    # {
    #  name = "extraArgs.scan-interval"
    #  value = "20s"
    #}    
  ]
}
