# main.tf

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


resource "aws_s3_bucket" "mcloud_showcase" {
  bucket  = "mcloud_showcase_jean_s3"
  tags    = {
	Name          = "mcloud_showcase_jean"
	Environment    = "Dev"
  }
}