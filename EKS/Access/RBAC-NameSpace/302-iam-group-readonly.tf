# a group
resource "aws_iam_group" "eks_readonly_group" {
  name = "eks-readonly"
  path = "/"
}
resource "aws_iam_group_policy" "eks_readonly_group_policy" {
  name  = "eks-readonly-group-policy"
  group = aws_iam_group.eks_readonly_group.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Sid      = "AllowAssumeRole"
        Resource = aws_iam_role.eks_readonly_role.arn
      }
    ]
  })
}
# a user in group
resource "aws_iam_user" "readonly_user_group" {
  name          = "eks-readonly-group"
  path          = "/"
  force_destroy = true # --> allows to delete the user even if it has access keys or other resources attached to it
}

resource "aws_iam_user_group_membership" "readonly_user_group_membership" {
  user   = aws_iam_user.readonly_user_group.name
  groups = [aws_iam_group.eks_readonly_group.name]
}
