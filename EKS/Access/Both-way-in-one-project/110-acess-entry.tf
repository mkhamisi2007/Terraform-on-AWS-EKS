#------------------- access entry and policy association for cluster admin access ------------------#
resource "aws_eks_access_entry" "root_access" {
  depends_on    = [aws_eks_cluster.eks_cluster]
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::**********:root"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "root_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.root_access.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

}
# ------------------ access entry and policy association for cluster ali access --------------------#
resource "aws_eks_access_entry" "ali_access" {
  depends_on    = [aws_eks_cluster.eks_cluster]
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::***********:user/ali"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "ali_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.ali_access.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
resource "time_sleep" "wait_for_eks_access" {
  depends_on = [
    aws_eks_access_policy_association.ali_admin
  ]
  create_duration = "60s"
}


