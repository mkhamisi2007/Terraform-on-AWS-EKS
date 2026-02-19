my-terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
---------------------------------------------------------- main.tf -- use it
provider "aws" {
  region = "eu-west-1"
}

module "my_ec2" {
  source = "./modules/ec2" #---------------------------> path

  ami_id         = "ami-0c55b159cbfafe1f0" #---------------------------> parameter 
  instance_type  = "t2.micro"#---------------------------> parameter
  instance_name  = "my-first-module-ec2"#---------------------------> parameter
}
------------------------------------------------------------------------------------------------------------modules
----------------------------------------------------------modules/ec2/main.tf
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
----------------------------------------------------------modules/ec2/variables.tf
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}
----------------------------------------------------------modules/ec2/outputs.tf
output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
----------------------------------------------------------
