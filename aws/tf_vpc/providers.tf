# Define terraform aws provider block for terraform to use
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Use ap-southeast-2 region for creating aws resources
provider "aws" {
  region = "ap-southeast-2"
}
