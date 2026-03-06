# create a Role for EKS admin access and attach a policy to it. This role will be used by the root user and ali user to access the EKS cluster. The policy attached to this role allows full access to EKS and also allows listing IAM roles and getting parameters from SSM. This is necessary for the users to be able to manage the EKS cluster and also to be able to assume the role when they need to access the cluster.
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

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

resource "aws_iam_role_policy" "eks_admin_role_policy" {
  name = "eks-admin-role-policy"
  role = aws_iam_role.eks_admin_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*",
          "iam:ListRoles",
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })
}