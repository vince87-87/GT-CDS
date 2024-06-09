# Terraform Block
terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket         = "cds-app-terraform-state"
    key            = "bootstrap/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state"
    profile        = "twn" # based on ~/.aws/credentials
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = var.region
  profile = "twn" # based on ~/.aws/credentials
}