-------------------------------------------------------------------------First way Remote State-----------------------------------------------------
--------------------------------------Project 1 ------------------------------------export
output "vpc_id" {
  value = aws_vpc.main.id
}
--------------------------------------Project 2 ------------------------------------import
# it is in S3 backend (shared terraform.tfstate in S3 with your application)
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

-------------------------------------------------------------------------Second way and local file with module-----------------------------------------------------
-------------------------Project 1--------------------------------
output "vpc_id" {
  value = aws_vpc.main.id
}
-------------------------Project 2--------------------------------
module "network" {
  source = "./network" #------> local file path
}

resource "aws_instance" "example" {
  subnet_id = module.network.vpc_id
}
