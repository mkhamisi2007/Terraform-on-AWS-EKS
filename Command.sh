Terraform Workflow
├── 1) init
│   ├── Command: terraform init
│   ├── Downloads providers (AWS, Azure, GCP, etc.)
│   ├── Downloads modules
│   ├── Initializes backend (local, S3, Terraform Cloud, etc.)
│   └── Creates .terraform/ directory and terraform.lock.hcl
│
├── 2) validate
│   ├── Command: terraform validate
│   └── Checks syntax and internal consistency of .tf files
│
├── 3) plan
│   ├── Command: terraform plan
│   ├── Compares desired state (code) with current state
│   ├── Shows execution plan (create / update / delete)
│   └── Optional:
│       └── terraform plan -out=tfplan (save the plan)
│
├── 4) apply
│   ├── Command: terraform apply
│   ├── Executes the planned changes
│   ├── Creates, updates, or deletes resources
│   └── If a plan file exists:
│       └── terraform apply tfplan
│
└── 5) destroy
    ├── Command: terraform destroy
    └── Deletes all resources managed by Terraform
--------------------------------------------------
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
































