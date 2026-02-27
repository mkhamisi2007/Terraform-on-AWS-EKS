terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "mohammad-khamisi-us-bucket"             #-------> S3 bucket name (shoud be exist)
    key    = "Terraform/kubernetes/terraform.tfstate" #----> folder & file name
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "my-test-table-for-terraform" # -----------> DynamoDB name created below (Partition key = LockID(String) )
  }
}

provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = var.aws_region
}

# read the remote state file of EKS cluster created in 003-EKS-one-node module
data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}


