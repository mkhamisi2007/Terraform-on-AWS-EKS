ec2/
├── main.tf        # resources
├── variables.tf   # inputs
├── outputs.tf     # outputs
└── README.md      # documentation (best practice)
-------------------main.tf---------------------
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
}
-------------------variables.tf---------------------
variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
--------------------outputs.tf--------------------
output "instance_id" {
  value = aws_instance.this.id
}
------------------User Module-------------------------------------------------------------
module "web_server" {
  source         = "./modules/ec2"
  ami            = "ami-123456"
  instance_type  = "t2.micro"
}
------------------------------------------------------------------------------------------
