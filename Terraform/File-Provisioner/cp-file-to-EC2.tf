provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "my_server" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
  key_name      = "my-key"

  provisioner "file" {
    source      = "index.html" #-------------> file in local system
    destination = "/home/ubuntu/index.html"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("my-key.pem")
      host        = self.public_ip
    }
  }
}
