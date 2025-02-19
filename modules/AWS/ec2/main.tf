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


# Create an EC2 Instance
resource "aws_instance" "ec2-mcloud-showcase-instance" {
  ami           = "ami-0cdd6d7420844683b" # Amazon Linux 2 AMI (us-east-1). Update as needed.
  instance_type = "t2.micro"

  tags = {
    Name = "${var.ec2_name}-${random_uuid.uuid.result}"
  }
}

resource "random_uuid" "uuid" {}


