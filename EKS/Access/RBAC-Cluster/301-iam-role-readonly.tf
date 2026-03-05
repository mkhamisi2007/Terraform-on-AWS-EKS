# create a Role for EKS readonly access and attach a policy to it. This role will be used by the root user and ali user to access the EKS cluster. The policy attached to this role allows readonly access to EKS and also allows listing IAM roles and getting parameters from SSM. This is necessary for the users to be able to manage the EKS cluster and also to be able to assume the role when they need to access the cluster.
resource "aws_iam_role" "eks_readonly_role" {
  name = "eks-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "eks_readonly_role_policy" {
  name = "eks-readonly-role-policy"
  role = aws_iam_role.eks_readonly_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListRoles",
          "ssm:GetParameter",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi",
          "eks:ListUpdates",
          "eks:ListFargateProfiles",
          "eks:ListIdentityProviderConfigs",
          "eks:ListAddons",
          "eks:DescribeAddonVersions"
        ]
        Resource = "*"
      }
    ]
  })
}
