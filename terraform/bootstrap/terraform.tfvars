# common
region           = "ap-southeast-1"
application_name = "cds-app"
ecr_name         = ["pythonapp-redis"]
create_s3_bucket = true
common_tags = {
  Terraform = "True"
}
