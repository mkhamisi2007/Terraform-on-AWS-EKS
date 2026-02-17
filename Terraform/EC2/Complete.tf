# 1 EC2 - 2 Security group - with 2 output
#--------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = var.aws_region
}
#--------------------------------------------------EC2----------------------------------------------------
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amzn_linux2.id
  instance_type = var.instance_type
  user_data     = file("command.sh") # file("${path.module}/command.sh") # Absolute path to file
  key_name = var.instance_keypaire
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id , aws_security_group.vpc-web.id ]
  tags = {
    Name = "Terraform-EC2"
  }
}
#--------------------------------------------------variable----------------------------------------------------
variable "aws_region" {
  description = "region for resource"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "ec2 type"
  type        = string
  default     = "t2.micro"
  sensitive   = true
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "instance type must be t2.micro or t3.micro"
  }
}
variable "instance_keypaire" {
  description = "key paire"
  type        = string
  default     = "AWS-key"
}
#--------------------------------------------------security_group----------------------------------------------------
resource "aws_security_group" "vpc-ssh" {
  name        = "terraform-security-group-ssh"
  description = "Security group for Terraform EC2 instance ssh access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Security-Group-SSH"
  }
}

resource "aws_security_group" "vpc-web" {
  name        = "terraform-security-group-web"
  description = "Security group for Terraform EC2 instance web access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Security-Group-web"
  }
}
#--------------------------------------------------DataSource----------------------------------------------------
data "aws_ami" "amzn_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (name: al2023-ami-2023.10.20260202.2-kernel-6.1-x86_64)
  }
  filter {
    name   = "root-device-type" # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (root-device-type: ebs)
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type" # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (virtualization-type: hvm)
    values = ["hvm"]
  }
  filter {
    name   = "architecture" # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (architecture: x86_64)
    values = ["x86_64"]
  }

}
#--------------------------------------------------output----------------------------------------------------
output "instance_public_ip" {
    description = "ec2 ip"
    value       = aws_instance.my_ec2.public_ip
}
output "instance_public_dns" {
    description = "ec2 public dns"
    value       = aws_instance.my_ec2.public_dns
}
#------------------------------------------------------------------------------------------------------
# instance_public_dns = "ec2-54-175-199-190.compute-1.amazonaws.com"
# instance_public_ip = "54.175.199.190"






