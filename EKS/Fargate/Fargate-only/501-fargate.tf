resource "kubernetes_namespace_v1" "fargate_ns" {
  depends_on = [time_sleep.wait_for_eks_access, aws_eks_addon.coredns]
  metadata {
    name = "fargate-ns" #-----> the namespace for fargate
  }
}
resource "aws_iam_role" "fargate_profile_role" {
  depends_on = [time_sleep.wait_for_eks_access]
  name       = "eks-fargete-profile-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_profile_role.name
}

resource "aws_eks_fargate_profile" "fargete_profile" {
  depends_on             = [time_sleep.wait_for_eks_access]
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "fp-apps"
  pod_execution_role_arn = aws_iam_role.fargate_profile_role.arn
  subnet_ids             = module.vpc.private_subnets
  selector {
    namespace = kubernetes_namespace_v1.fargate_ns.metadata.0.name # "fargate-ns" #-----> the namespace for fargate
  }
}

#------------------------------------------------cretae a profile for kube-system pods------------------------
resource "aws_eks_fargate_profile" "fargete_profile_kube_system" {
  depends_on             = [time_sleep.wait_for_eks_access]
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "fp-kube-system"
  pod_execution_role_arn = aws_iam_role.fargate_profile_role.arn
  subnet_ids             = module.vpc.private_subnets
  selector {
    namespace = "kube-system"
    /* or we can use labels
    labels = {
      "k8s-app" = "kube-dns"
    }*/
  }
}
#------------------------------------------------cretae a profile for default pods------------------------
resource "aws_eks_fargate_profile" "fargete_profile_default" {
  depends_on             = [time_sleep.wait_for_eks_access]
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "fp-default"
  pod_execution_role_arn = aws_iam_role.fargate_profile_role.arn
  subnet_ids             = module.vpc.private_subnets
  selector {
    namespace = "default"
    /* or we can use labels
    labels = {
      "k8s-app" = "kube-dns"
    }*/
  }
}
#-----------------------------------------------------------------------------------------------------------

