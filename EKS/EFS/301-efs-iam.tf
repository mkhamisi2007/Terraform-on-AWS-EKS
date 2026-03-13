
# Datasource: EFS CSI IAM Policy get from EFS GIT Repo (latest)
data "http" "efs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}
# Resource: Create EFS CSI IAM Policy 
resource "aws_iam_policy" "efs_csi_iam_policy" {
  name        = "AmazonEKS_EFS_CSI_Driver_Policy"
  path        = "/"
  description = "EFS CSI IAM Policy"
  policy = data.http.efs_csi_iam_policy.response_body
}

# Resource: Create IAM Role and associate the EFS IAM Policy to it
resource "aws_iam_role" "efs_csi_iam_role" {
  name = "efs-csi-iam-role"

# Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }        
      },
    ]
  })

  tags = {
    tag-key = "efs-csi"
  }
}

# Associate EFS CSI IAM Policy to EFS CSI IAM Role
resource "aws_iam_role_policy_attachment" "efs_csi_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.efs_csi_iam_policy.arn 
  role       = aws_iam_role.efs_csi_iam_role.name
}
