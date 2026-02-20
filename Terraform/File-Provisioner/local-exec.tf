resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ip.txt" #-------------> it will be printed in local system
  }
}
