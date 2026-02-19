locals {
  service_name = "forum"
  owner        = "community-team"
  environment  = "production"
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name        = local.service_name
    Owner       = local.owner
    Environment = local.environment
  }
}
----------------------------------------------------------------
variable "owners" {
  description = "owner for resource"
  type        = string
  default     = "mohammad"
}
variable "environment" {
  description = "environment for resource"
  type        = string
  default     = "dev"
}

locals {
  instance_ids = concat(aws_instance.blue[*].id, aws_instance.green[*].id)
  owners      = var.owners
  environment = var.environment
  name        = "${var.owners}-${var.environment}"
  othername   = "${local.owners}-${var.environment}"
  commontags = {
    Owner       = local.owners
    Environment = local.environment
  }

}
----------------------------------------------------------------
----------------------------------------------------------------
