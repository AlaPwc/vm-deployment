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
resource "aws_instance" "mcloud_showcase_ec2" {
  ami           = "ami-0cdd6d7420844683b"  # Amazon Linux 2 AMI (us-east-1). Update as needed.
  instance_type = "t2.micro"

  # Optionally, specify an existing key pair for SSH access
  # key_name = "your-existing-key-pair"

  # Optionally, specify security groups or VPC settings
  # vpc_security_group_ids = ["sg-12345678"]
  # subnet_id              = "subnet-abc12345"

  tags = {
    Name = "mcloud_showcase_ec2"
  }
}
