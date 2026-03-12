resource "kubernetes_namespace_v1" "fp_ns_app1" {
  depends_on = [time_sleep.wait_for_eks_access]
  metadata {
    name = "fargate-ns" #-----> the namespace for fargate
  }
}
resource "aws_iam_role" "fargate_profile_role" {
  name = "eks-fargete-profile-role"
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
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "fp-app1"
  pod_execution_role_arn = aws_iam_role.fargate_profile_role.arn
  subnet_ids             = module.vpc.private_subnets
  selector {
    namespace =  kubernetes_namespace_v1.fp_ns_app1.metadata.0.name # "fargate-ns" #-----> the namespace for fargate
  }
}
