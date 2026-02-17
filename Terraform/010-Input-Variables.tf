terraform apply -var="region=us-east-1"
-----------------------------------------------------------
export TF_VAR_region="us-east-1"
-----------------------------------------------------------
# any-name.tfvars OR Default one (terraform.tfvars) without -var
region = "us-east-1"
instance_type = "t3.micro"
---
terraform apply -var-file="any-name.tfvars" 
-----------------------------------------------------------
# Automaticly uploded
*.auto.tfvars
-----------------------------------------------------------
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}
---
provider "aws" {
  region = var.region #----> use it
}
-----------------------------------------------------------
# for password
variable "db_password" {
  type      = string
  sensitive = true
}
-----------------------------------------------------------
# validate variable
variable "instance_type" {
  type = string

  validation {
    condition     = contains(["t2.micro","t3.micro"], var.instance_type) #----> it shoud be one of ["t2.micro","t3.micro"]
    error_message = "Invalid instance type!"
  }
}
-----------------------------------------------------------
# list
variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
}
---
availability_zones = ["eu-west-3a", "eu-west-3b"]
---
resource "aws_subnet" "example" {
  count             = length(var.availability_zones) #----> 2 subnet in 2 AZ
  vpc_id            = "vpc-123456"
  availability_zone = var.availability_zones[count.index] #----> select the AZ
  cidr_block        = "10.0.${count.index}.0/24"
}
----------------------------------------------------------- example--------------------------------------------------------
# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = "terraform-key"
  count                  = var.ec2_instance_count
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "myec2vm"
  }
}








