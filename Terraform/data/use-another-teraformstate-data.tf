--------------------------------------Project 1 ------------------------------------export
output "vpc_id" {
  value = aws_vpc.main.id
}
--------------------------------------Project 2 ------------------------------------import
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-on-aws-for-ec2"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
--------------------------------------Or if it is in S3 backend---------------------- import from S3
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-on-aws-for-ec2"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
---------------------------------------Use it---------------------------------------
resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_id
}

