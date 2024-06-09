# Terraform Block
terraform {
  required_version = ">= 1.0"
  backend "s3" {
    # bucket         = "cds-app-terraform-state"
    # key            = "iac/dev/terraform.tfstate"
    # region         = "ap-southeast-1"
    # encrypt        = true
    # dynamodb_table = "terraform-state"
    # profile        = "twn" # based on ~/.aws/credentials
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  }
}

# Provider Block
provider "aws" {
  region  = var.region
  profile = "twn" # based on ~/.aws/credentials
}