data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-on-aws-for-ec2"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
