terraform apply -var="region=us-east-1"
-----------------------------------------------------------
export TF_VAR_region="us-east-1"
-----------------------------------------------------------
# any-name.tfvars OR Default one (terraform.tfvars) without -var
region = "us-east-1"
instance_type = "t3.micro"
---
terraform apply -var-file="any-name.tfvars" 
-----------------------------------------------------------
# Automaticly uploded
*.auto.tfvars
-----------------------------------------------------------
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}
---
provider "aws" {
  region = var.region #----> use it
}
-----------------------------------------------------------
# for password
variable "db_password" {
  type      = string
  sensitive = true
}
-----------------------------------------------------------
# validate variable
variable "instance_type" {
  type = string

  validation {
    condition     = contains(["t2.micro","t3.micro"], var.instance_type) #----> it shoud be one of ["t2.micro","t3.micro"]
    error_message = "Invalid instance type!"
  }
}
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------








