data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
  request_headers = {
    "Accept" = "application/json"
  }
}
resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "lbc-iam-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.http.lbc_iam_policy.response_body
  path        = "/"
}
resource "aws_iam_role" "lbc_iam_role" {
  name        = "lbc-iam-role"
  description = "IAM role for AWS Load Balancer Controller"
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
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com",
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attachment" {
  role       = aws_iam_role.lbc_iam_role.name
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
}
