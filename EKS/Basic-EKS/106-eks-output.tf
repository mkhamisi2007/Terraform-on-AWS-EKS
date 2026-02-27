
resource "null_resource" "kubeconfig" {
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks_private_nodegroup,
    aws_eks_node_group.eks_public_nodegroup
  ]

  /*
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.eks_cluster.name} --kubeconfig ${path.module}\\kubeconfig_${aws_eks_cluster.eks_cluster.name}"
  }
*/
  provisioner "local-exec" {
    command = <<EOT
    aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.eks_cluster.name} --kubeconfig ${path.module}\\kubeconfig_${aws_eks_cluster.eks_cluster.name}
    $env:KUBECONFIG = "$PWD\kubeconfig_my_eks_cluster"
    set-alias k kubectl
    EOT

    interpreter = ["PowerShell", "-Command"]
  }

  triggers = {
    cluster_name = aws_eks_cluster.eks_cluster.name
  }
}

# ----------or you can use this output to get the cluster region from the cluster resource
output "cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.eks_cluster.id
}

