/*
#its for local backend, if you want to use remote backend (S3) you should change the backend configuration in 001-main.tf file and then run terraform init command again to reconfigure the backend and then you can use the below code to get output values from the remote state file of EKS cluster created in 003-EKS-one-node module
data "terraform_remote_state" "eks" {
    backend = "local"
    config = {
        path = "../003-EKS-one-node/terraform.tfstate"
    }
}
*/
# get output values from the remote state file of EKS cluster created in 003-EKS-one-node module
#data.terraform_remote_state.eks.outputs.cluster_id

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "mohammad-khamisi-us-bucket"      #-------> S3 bucket name (shoud be exist)
    key    = "Terraform/eks/terraform.tfstate" #----> folder & file name (refrenced in 003-EKS-one-node module)
    region = "us-east-1"
  }

}
