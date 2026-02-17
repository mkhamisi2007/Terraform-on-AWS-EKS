# The data block allows Terraform to read existing infrastructure
-----------------------------------------------------------
# get default vpc
data "aws_vpc" "existing" {
  default = true
}
-----------------------------------------------------------
# get subnets od vpc
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}
-----------------------------------------------------------
# get default security group
data "aws_security_group" "ssh" {
  name = "default"
}
-----------------------------------------------------------
# get account id
data "aws_caller_identity" "current" {}
# data.aws_caller_identity.current.account_id
-----------------------------------------------------------
# get default region
data "aws_region" "current" {}
-----------------------------------------------------------
# get EKS cluster
data "aws_eks_cluster" "cluster" {
  name = "my-cluster"
}
-----------------------------------------------------------

