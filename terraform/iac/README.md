```

export ENV="dev"

terraform init \
  -backend-config="bucket=cds-app-terraform-state" \
  -backend-config="key=iac/${ENV}/terraform.tfstate" \
  -backend-config="region=ap-southeast-1" \
  -backend-config="encrypt=true" \
  -backend-config="dynamodb_table=terraform-state" \
  -backend-config="profile=twn"

  ```

  route53
  acm
