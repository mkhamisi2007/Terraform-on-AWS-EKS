
resource "null_resource" "kubeconfig" {
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]


  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.eks_cluster.name} --kubeconfig ${path.module}\\kubeconfig_${aws_eks_cluster.eks_cluster.name}"
  }
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "aws sns publish --cli-input-json file://sns.json"
  }

  triggers = {
    cluster_name = aws_eks_cluster.eks_cluster.name
  }
}

#------------------- outputs for kubernetes cluster access ------------------#

/*
output "kubernetes_host" {
  description = "EKS Cluster Endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "kubernetes_cluster_ca_certificate" {
  description = "EKS Cluster CA Certificate"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}
output "kubernetes_token" {
  description = "Authentication token for EKS"
  value       = data.aws_eks_cluster_auth.eks_cluster_auth.token
  sensitive   = true
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.eks_cluster.name
}
*/

# ----------or you can use this output to get the cluster region from the cluster resource
output "cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.eks_cluster.id
}
