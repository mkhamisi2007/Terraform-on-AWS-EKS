variable "instance_type_bastion" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

# AWS EC2 Instance Key Pair
variable "instance_keypair_bastion" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "./Key/AWS-key.pem"
}
variable "instance_keypaire_bastin_name" {
  description = "EC2 key pair name"
  default     = "AWS-key"
}
/*
#------------------- EC2 Bastion Host ------------------#
resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type_bastion
  key_name               = var.instance_keypaire_bastin_name
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]


  provisioner "file" {
    source      = var.instance_keypair_bastion
    destination = "/home/ec2-user/AWS-key.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.instance_keypair_bastion)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Terraform-EC2"
  }

}

resource "null_resource" "deploy_script" {

  depends_on = [aws_instance.my_ec2]

  triggers = {
    instance_id = aws_instance.my_ec2.id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.instance_keypair_bastion)
    host        = aws_instance.my_ec2.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /home/ec2-user/AWS-key.pem"
    ]
  }
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_ec2.id
  domain   = "vpc"
  tags = {
    Name = "My-EIP"
  }
}
*/
