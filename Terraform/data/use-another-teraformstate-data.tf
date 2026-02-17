data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-on-aws-for-ec2"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
------------------------------------Use it in another terraform project -------------------------------
resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_id
}
