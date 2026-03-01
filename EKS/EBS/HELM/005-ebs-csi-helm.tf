data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token

  }
}

resource "helm_release" "ebs_csi_driver" {
  depends_on = [aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attachment]

  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  #version    = "2.24.0"
  namespace = "kube-system"

  set = [{
    name  = "controller.serviceAccount.create"
    value = "true"
    },
    {
      name  = "controller.serviceAccount.name"
      value = "ebs-csi-controller-sa"
    },
    {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-ebs-csi-driver"
      # you can find the list here -> https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
    },
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = "${aws_iam_role.ebs_csi_iam_role.arn}"
  }]

}

/*
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update

helm upgrade --install aws-ebs-csi-driver \
  aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \
  --version 2.24.0 \
  --set controller.serviceAccount.create=true \
  --set controller.serviceAccount.name=<SERVICE_ACCOUNT_NAME> \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-ebs-csi-driver \
  --set controller.serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<IAM_ROLE_ARN>
  */
