/*resource "aws_eks_node_group" "eks_public_nodegroup" {
  cluster_name    = var.cluster_name
  node_group_name = "public-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = module.vpc.public_subnets

  #version         = var.eks_cluster_version # (opthinal) you can specify diffrent version of your kubernetes version = default is current cluster version

  # you can see the list here => https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
  ami_type       = "AL2023_x86_64_STANDARD" #--> Amazon Linux 2 (AL2) AMI for x86_64 architecture
  capacity_type  = "ON_DEMAND"              #--> ON_DEMAND or SPOT
  disk_size      = 20                       #--> disk size in GB
  instance_types = ["t3.medium"]            #--> you can specify one or more instance types for your node group
  remote_access {
    ec2_ssh_key = var.instance_keypaire #--> for ssh to our ec2s
  }
  scaling_config {
    desired_size = 0
    max_size     = 1
    min_size     = 0
  }
  # for node group update strategy
  update_config {
    max_unavailable = 1 #OR  max_unavailable_percentage = 50 
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.eks_nodegroup_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.eks_ecr_readonly_policy_attachment
  ]
  tags = {
    Name = "public-node-group"
  }
}*/
