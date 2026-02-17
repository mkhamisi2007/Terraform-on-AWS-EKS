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
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------








