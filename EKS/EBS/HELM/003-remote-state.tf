# eks cluster remote state data source
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mohammad-khamisi-us-bucket"      #-------> S3 bucket name (shoud be exist)
    key    = "Terraform/eks/terraform.tfstate" #----> folder & file name (refrenced in 003-EKS-one-node module)
    region = var.aws_region
  }

}
