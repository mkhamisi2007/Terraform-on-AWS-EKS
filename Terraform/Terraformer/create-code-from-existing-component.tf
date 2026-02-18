# download the exe file and set it in envirement variable in path
https://github.com/GoogleCloudPlatform/terraformer
terraformer --version
----------------------------------------------------
$env:AWS_PROFILE="default"
$env:AWS_DEFAULT_REGION="us-east-1"
terraform init
terraformer import aws --resources=vpc
terraformer import aws --resources=vpc,subnet,ec2 
-------------------------------------------------------
output will be store in =====> generated\aws
