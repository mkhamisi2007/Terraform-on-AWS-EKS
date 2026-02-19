when we define a file "terraform.tfvars" , it will replace our value in "variable" block
------------------------------------------------------------------ 
# main terraform file
variable "aws_region" {
  description = "region for resource"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "environment for resource"
  type        = string
  default     = "dev"
}
------------------------------------------------------------------
# terraform.tfvars
aws_region = "us-west-1"  #---------------> replace "us-east-1" to "us-west-1"
environment =  "prod"  #---------------> replace "dev" to "prod"
