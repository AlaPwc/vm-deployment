terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#test

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

domain_name = "mcloud-showcase"
bucket_name = "mcloud-showcase-bucket"
