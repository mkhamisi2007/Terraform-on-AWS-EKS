aws dynamodb create-table \
  --table-name my-test-table-for-terraform \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
#use 
terraform init -reconfigure 
terraform plan
# record will inserted in DynamoDB (mohammad-khamisi-us-bucket/dev2/terraform.tfstate - {"ID":"822cb1a5-adb0-4d3a-43f5-420dd6f3631f","Operation":"OperationTypePlan","Info":"","Who":"KHAMISI\\Administrateur@KHAMISI","Version":"1.14.4","Created":"2026-02-11T08:36:46.7714652Z","Path":"mohammad-khamisi-us-bucket/dev2/terraform.tfstate"}
