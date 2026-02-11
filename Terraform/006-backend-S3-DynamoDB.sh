terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage with State Locking
  backend "s3" {
    bucket = "mohammad-khamisi-us-bucket" #-------> S3 bucket name
    key    = "dev2/terraform.tfstate" #----> folder & file name
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "my-test-table-for-terraform" # -----------> DynamoDB name created below (Partition key = LockID(String) )
  }
}
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "us-east-1"
}
----------------------------------------------------------------------------------------------------------------
aws dynamodb create-table \
  --table-name my-test-table-for-terraform \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
  
#use "-reconfigure" for change or update Backend
terraform init -reconfigure 
terraform plan
# record will inserted in DynamoDB when start plan 
# record will deleted after finish plan
# mohammad-khamisi-us-bucket/dev2/terraform.tfstate - {"ID":"822cb1a5-adb0-4d3a-43f5-420dd6f3631f","Operation":"OperationTypePlan","Info":"","Who":"KHAMISI\\Administrateur@KHAMISI","Version":"1.14.4","Created":"2026-02-11T08:36:46.7714652Z","Path":"mohammad-khamisi-us-bucket/dev2/terraform.tfstate"}

terraform apply
# record will inserted in DynamoDB when start apply 
# record will deleted after finish apply
# "terraform.tfstate" file will copy in S3






