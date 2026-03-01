
locals {
  # از remote state پروژه اول
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  oidc_issuer_url   = data.terraform_remote_state.eks.outputs.oidc_issuer_url
  oidc_issuer_host  = replace(local.oidc_issuer_url, "https://", "")
}
#dowload the EBS CSI driver IAM policy from the official GitHub repository and create an AWS IAM policy resource with it.
data "http" "ebs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
  request_headers = {
    "Accept" = "application/json"
  }
}

resource "aws_iam_policy" "ebs_csi_iam_policy" {
  name        = "ebs-csi-iam-policy"
  description = "IAM policy for EBS CSI driver"
  policy      = data.http.ebs_csi_iam_policy.response_body
}

resource "aws_iam_role" "ebs_csi_iam_role" {
  name = "ebs-csi-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = local.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_issuer_host}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attachment" {
  role       = aws_iam_role.ebs_csi_iam_role.name
  policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn
}
