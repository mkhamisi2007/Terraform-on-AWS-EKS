resource
├── count
├── for_each
├── depends_on
├── provider
└── lifecycle
    ├── create_before_destroy
    ├── prevent_destroy
    └── ignore_changes
------------------count------------------------
resource "aws_instance" "web" {
  count         = 2
  instance_type = "t2.micro"
}
...
aws_instance.web[0]
aws_instance.web[1]
------------------for_each------------------------
resource "aws_instance" "web" {
  for_each      = toset(["dev", "prod"])
  instance_type = "t2.micro"
}
...
aws_instance.web["dev"].id
-----------------depends_on-------------------------
resource "aws_instance" "web" {
  depends_on = [aws_security_group.sg]
}
------------------lifecycle------------------------
resource "aws_instance" "web" {
  lifecycle {
    prevent_destroy = true
  }
}
-----------------lifecycle-------------------------
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
  ignore_changes        = [tags]
}
-----------------provider-------------------------
resource "aws_instance" "eu" {
  provider = aws.europe
}
------------------Exmple-------------------------
resource "aws_instance" "web" {
  count         = 2
  instance_type = "t2.micro"

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [aws_security_group.sg]
}



