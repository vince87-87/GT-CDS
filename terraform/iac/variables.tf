variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "application_name" {
  description = "name of application"
  type        = string
  default     = "my-app"
}

variable "create_s3_bucket" {
  type    = bool
  default = false
}

variable "create_s3_acl" {
  type    = bool
  default = false
}

variable "common_tags" {
  type        = map(any)
  description = "common tag to be tag on all resource"
  default     = {}
}

variable "create_ecr" {
  type    = bool
  default = false
}

variable "ecr_name" {
  type    = list(any)
  default = null
}

variable "key" {
  type    = string
  default = "iac/dev/terraform.tfstate"
}

variable "instance_type" {
  type = string
}