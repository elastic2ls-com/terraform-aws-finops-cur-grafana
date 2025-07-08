```
aws sso login --profile staffing-tool-test 
terraform init --backend-config=backend/test.tfbackend 
terraform plan -var-file=test.tfvars 
```