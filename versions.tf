terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }

  # Optional remote state. Create the bucket first, then uncomment and run
  # `terraform init -migrate-state`.
  # backend "s3" {
  #   bucket       = "your-terraform-state-bucket"
  #   key          = "aws-vpc-terraform/terraform.tfstate"
  #   region       = "us-east-1"
  #   use_lockfile = true
  #   encrypt      = true
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = var.project
      ManagedBy = "terraform"
      Env       = var.environment
    }
  }
}
