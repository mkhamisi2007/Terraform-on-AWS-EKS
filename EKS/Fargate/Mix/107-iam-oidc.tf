data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "tls" {}
data "tls_certificate" "oidc" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  depends_on = [aws_eks_cluster.eks_cluster]

  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.oidc.certificates[0].sha1_fingerprint
  ]
}


output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer_url" {
  value = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}
