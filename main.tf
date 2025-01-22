# main.tf
terraform {
  required_version = ">= 1.3.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }



#test

# 1. Specify the AWS provider and region.
provider "aws" {
  region = "us-east-1"
  # or any region you prefer
}
   
   
   
# 2. Create a VPC Security Group to allow SSH/HTTP/HTTPS if needed.
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Example security group allowing SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For demonstration; restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-sg"
  }
}

# 3. Retrieve the default VPC ID for the region
data "aws_vpc" "default" {
  default = true
}

# 4. Retrieve a default subnet (for example, public subnets) from the default VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# 5. Create the EC2 instance
resource "aws_instance" "example_ec2" {
  ami                    = "ami-08d4ac5b634553e16"  # Example Amazon Linux 2 AMI in us-east-1, update as needed
  instance_type          = "t2.micro"
  subnet_id              = element(data.aws_subnet_ids.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  # (Optional) Add SSH key, if you want to connect via terminal:
  key_name = "your-existing-key-pair"

  tags = {
    Name = "example-ec2"
  }
}
