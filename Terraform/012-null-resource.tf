#it will be executed on time
resource "null_resource" "example" {

  provisioner "local-exec" {
    command = "echo Hello Terraform"
  }
}
-----------------------------------------------
resource "null_resource" "run_script" {

  triggers = {
    always_run = timestamp() #---> we can trigger it with time , so it will be executed on every apply command
  }

  provisioner "local-exec" {
    command = "echo Script executed"
  }
}
----------------------------------------------
resource "aws_instance" "demo" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}

resource "null_resource" "after_instance" {

  depends_on = [aws_instance.demo] #------------>

  provisioner "local-exec" {
    command = "echo Instance created!"
  }
}
--------------------------------------------------use with File provision
resource "aws_instance" "demo" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
  key_name      = "my-key"
}

resource "null_resource" "deploy_script" {

  depends_on = [aws_instance.demo]

  triggers = {
    instance_id = aws_instance.demo.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("my-key.pem")
    host        = aws_instance.demo.public_ip
  }

  provisioner "file" {
    source      = "app.sh"
    destination = "/home/ubuntu/app.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/app.sh",
      "/home/ubuntu/app.sh"
    ]
  }
}
