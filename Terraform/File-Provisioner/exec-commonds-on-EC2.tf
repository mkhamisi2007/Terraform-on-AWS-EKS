provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"   # Ubuntu AMI
  instance_type = "t3.micro"
  key_name      = "my-key"

  vpc_security_group_ids = ["sg-xxxxxxxx"]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("my-key.pem")
      host        = self.public_ip
    }
  }
}
