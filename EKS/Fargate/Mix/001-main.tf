terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    time = {
      source = "hashicorp/time"
    }
  }
  backend "s3" {
    bucket = "mohammad-khamisi-us-bucket"      #-------> S3 bucket name (shoud be exist)
    key    = "Terraform/eks/terraform.tfstate" #----> folder & file name
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "my-test-table-for-terraform" # -----------> DynamoDB name created below (Partition key = LockID(String) )
  }
}
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = var.aws_region
}

