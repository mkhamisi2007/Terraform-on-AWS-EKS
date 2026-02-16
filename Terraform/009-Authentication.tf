------------------------------------------------------- direct
provider "aws" {
  region     = "us-east-1"
  access_key = "value"
  secret_key = "value"
}
------------------------------------------------------- Environment varaiable
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."   
export AWS_REGION="eu-west-3"
------------------------------------------------------- aws configure
aws configure
cat ~/.aws/credentials
[default]
aws_access_key_id = XXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXX
------------------------------------------------------- Loging in spacial profile
aws sso login --profile my-sso
------------------------------------------------------- Assume Role
provider "aws" {
  region  = "eu-west-3"
  profile = "base-user"

  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/TerraformRole"
    session_name = "terraform"
  }
}
-------------------------------------------------------
