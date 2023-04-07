terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "app_server" {
  ami           = "ami-08f0bc76ca5236b20"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
  
}
