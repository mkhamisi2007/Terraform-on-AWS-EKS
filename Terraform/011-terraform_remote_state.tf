# terraform_remote_state used for transfer data between 2 terraform project in S3 or local
----------------------------------------------------------------- project 2 
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "network/vpc.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
  }
}
output "vpc_id" {
  value = aws_vpc.main.id #-----------> output
}

output "public_subnets" {
  value = aws_subnet.public[*].id  #-----------> output
}
----------------------------------------------------------------- project 2 
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state-bucket"
    key    = "network/vpc.tfstate"
    region = "eu-west-1"
  }
}
resource "aws_security_group" "eks_sg" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id #------------> use it here

  name = "eks-security-group"
}
