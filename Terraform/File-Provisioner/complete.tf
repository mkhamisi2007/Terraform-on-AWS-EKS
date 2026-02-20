provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "demo" {
  ami           = "ami-xxxxxxxx"   # Ubuntu AMI
  instance_type = "t3.micro"
  key_name      = "my-key"

  vpc_security_group_ids = ["sg-xxxxxxxx"]

  provisioner "local-exec" {
    command = "echo EC2 ${self.id} is being created >> local_log.txt"
  }

  provisioner "file" {
    source      = "app.sh"
    destination = "/home/ubuntu/app.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("my-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
      source      = "config.json"
      destination = "/home/ubuntu/config.json"
  
      connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("my-key.pem")
        host        = self.public_ip
      }
    }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/app.sh",
      "/home/ubuntu/app.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("my-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo EC2 ${self.id} destroyed >> local_log.txt"
  }
}
