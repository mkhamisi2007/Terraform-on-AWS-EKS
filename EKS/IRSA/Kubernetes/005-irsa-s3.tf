locals {
  # از remote state پروژه اول
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  oidc_issuer_url   = data.terraform_remote_state.eks.outputs.oidc_issuer_url
  oidc_issuer_host  = replace(local.oidc_issuer_url, "https://", "")

  # ServiceAccount که می‌سازیم
  irsa_namespace = "default"
  irsa_sa_name   = "sa-s3-test"

  # اسم باکت برای تست
  s3_bucket_name = "mohammad-khamisi-us-bucket" # اگر خواستی var کن
}

# -----------------------------------------Trust policy & Role create------------------------------------------
data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_host}:sub"
      values   = ["system:serviceaccount:${local.irsa_namespace}:${local.irsa_sa_name}"]
    }
  }
}
# -----Role create---
resource "aws_iam_role" "irsa_s3_test" {
  name               = "irsa-s3-test-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
}

/*
#OR--------
resource "aws_iam_role" "irsa_s3_test" {
  name = "irsa-s3-test-role"

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
            "${local.oidc_issuer_host}:aud" = "sts.amazonaws.com"
            "${local.oidc_issuer_host}:sub" = "system:serviceaccount:${local.irsa_namespace}:${local.irsa_sa_name}"
          }
        }
      }
    ]
  })
}*/
#------------------------------- Policy S3 (ListBucket + GetObject)--------------------------------------
data "aws_iam_policy_document" "s3_min_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}"
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}/*"
    ]
  }
}
#-----Policy create---
resource "aws_iam_policy" "irsa_s3_min" {
  name   = "irsa-s3-test-min-policy"
  policy = data.aws_iam_policy_document.s3_min_policy.json
}

/*
#OR--------
resource "aws_iam_policy" "irsa_s3_min" {
  name = "irsa-s3-test-min-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::${local.s3_bucket_name}"
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${local.s3_bucket_name}/*"
      }
    ]
  })
}*/
#------------------------------- Attach Policy to Role --------------------------------------
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.irsa_s3_test.name
  policy_arn = aws_iam_policy.irsa_s3_min.arn
}
