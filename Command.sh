terraform version

terraform init

# check validation
terraform validate

# format code
terraform fmt

# show changes
terraform plan
terraform plan -out=tfplan

# Execution
terraform apply
terraform apply tfplan

# Remove resources
terraform destroy

# show current status
terraform show

# show list of resources
terraform state list
terraform state show aws_instance.web

# refresh status with existing rosorces
terraform refresh

# show list of environment
terraform workspace list
# create new env
terraform workspace new dev
# select env
terraform workspace select prod

#show list of providers(AWS,Azure,...)
terraform providers

# show outputs
terraform output
terraform output vpc_id

# interctive environment
terraform console
































