#------------------- IAM Admin Users for EKS Access ------------------#
resource "aws_iam_user" "admin_user" {
  name          = "eksadmin"
  path          = "/"
  force_destroy = true # --> allows to delete the user even if it has access keys or other resources attached to it
}
resource "aws_iam_user_policy_attachment" "admin_user_policy" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
#------------------- IAM Basic Users for EKS Access ------------------#
resource "aws_iam_user" "basic_user" {
  name          = "eksbasic"
  path          = "/"
  force_destroy = true # --> allows to delete the user even if it has access keys or other resources attached to it
}
resource "aws_iam_user_policy" "basic_user_inline_policy" {
  name = "my-eks-readonly"
  user = aws_iam_user.basic_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListRoles",
          "eks:*",
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })
}
/*
resource "aws_iam_user_policy_attachment" "basic_user_policy" {
  user       = aws_iam_user.basic_user.name
  policy_arn = aws_iam_user_policy.basic_user_inline_policy.arn
}*/
