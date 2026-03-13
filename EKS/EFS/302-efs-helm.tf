/*data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks_cluster.name
}
provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}*/

# Install EFS CSI Driver using HELM

# Resource: Helm Release 
resource "helm_release" "efs_csi_driver" {
  depends_on = [aws_iam_role.efs_csi_iam_role, time_sleep.wait_for_eks_access]
  name       = "aws-efs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"

  namespace = "kube-system"

  set = [
    {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-efs-csi-driver"
      # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
    },
    {
      name  = "controller.serviceAccount.create"
      value = "true"
    },
    {
      name  = "controller.serviceAccount.name"
      value = "efs-csi-controller-sa"
    },
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.efs_csi_iam_role.arn
    }
  ]
}
