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

resource "aws_instance" "my_ec2" {
  count = 2 #-----------------------------------------> Create 2 EC2 instances - count index starts with 0(count.index)
  ami           = data.aws_ami.amzn_linux2.id
  instance_type = var.instance_type_list[0] #-----------------------------------------> Accessing list variable
  #instance_type = var.instance_type_map["prod"] #----------------------------------------->Accessing map variable

  user_data     = file("command.sh") # file("${path.module}/command.sh") # Absolute path to file
  key_name = var.instance_keypaire
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id , aws_security_group.vpc-web.id ]
  tags = {
    Name = "Terraform-EC2 - ${count.index + 1}" #-----------------------------------------> *
  }

}
#--------------------------------------------------------------------------------------------------- List & Map
variable "aws_region" {
  description = "region for resource"
  type        = string
  default     = "us-east-1"
}
variable "instance_keypaire" {
  description = "key paire"
  type        = string
  default     = "AWS-key"
}
//------- List and Map variables #-----------------------------------------> *
variable "instance_type_list" {
  description = "list of ec2 types"
  type        = list(string)
  default     = ["t2.micro", "t3.micro"]
}
variable "instance_type_map" {
  description = "map of ec2 types"
  type        = map(string)
  default = {
    "dev"  = "t2.micro"
    "test" = "t2.micro"
    "prod" = "t3.micro"
  }
}
#---------------------------------------------------------------------------------------------------
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
#---------------------------------------------------------------------------------------------------
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
#--------------------------------------------------------------------------------------------------- OutPut
output "for_output_list" {
  description = "list of dns"
  value       = [for x in aws_instance.my_ec2 : x.public_dns]
}

output "for_output_map" {
  description = "map of dns"
  value       = { for x in aws_instance.my_ec2 : x.id => x.public_dns }
}

output "for_output_map2" {
  description = "map of instance types"
  value       = { for c, x in aws_instance.my_ec2 : c => x.public_dns } # another way to create map with count index as key
}

output "legacy_splat_intance_publicdns" {
  description = "legacy splat of public dns"
  value       = aws_instance.my_ec2.*.public_dns
}

output "latest_splat_intance_publicdns" {
  description = "latest splat of public dns"
  value       = aws_instance.my_ec2[*].public_dns
}
#--------------------------------------------------------------------------------------------------- result
for_output_list = [
  "ec2-18-234-163-99.compute-1.amazonaws.com",
  "ec2-98-94-86-194.compute-1.amazonaws.com",
]
for_output_map = {
  "i-08fff73e2743a13b2" = "ec2-18-234-163-99.compute-1.amazonaws.com"
  "i-0c7afd22af3d85b2d" = "ec2-98-94-86-194.compute-1.amazonaws.com"
}
for_output_map2 = {
  "0" = "ec2-18-234-163-99.compute-1.amazonaws.com"
  "1" = "ec2-98-94-86-194.compute-1.amazonaws.com"
}
latest_splat_intance_publicdns = [
  "ec2-18-234-163-99.compute-1.amazonaws.com",
  "ec2-98-94-86-194.compute-1.amazonaws.com",
]
legacy_splat_intance_publicdns = [
  "ec2-18-234-163-99.compute-1.amazonaws.com",
  "ec2-98-94-86-194.compute-1.amazonaws.com",
]
