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
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
