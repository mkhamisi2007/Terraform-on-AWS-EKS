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
