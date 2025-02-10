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

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-rds-aurora"
    GithubOrg  = "terraform-aws-modules"
  }
}

#test

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

data "aws_subnet" "subnet1" {
  id = "subnet-08fbbed3c2ada84b6"
}

data "aws_subnet" "subnet2" {
  id = "subnet-0ac42b550e73cf6b2"
}

resource "aws_security_group" "allow_aurora" {
  name        = "Aurora_sg_mcloud_showcase"
  description = "Security group for RDS Aurora"
  
  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_db_subnet_group" "mydb_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = [
    data.aws_subnet.subnet1.id,
    data.aws_subnet.subnet2.id
  ]
  
  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_rds_cluster" "aurorards" {
  cluster_identifier     = "myauroracluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.12.0"
  database_name          = "mcloud-showcase-db"
  master_username        = "DBtestAdmin"
  master_password        = "AdminTest4321DB"
  vpc_security_group_ids = [aws_security_group.allow_aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb_subnet_group.name
  storage_encrypted      = false
  skip_final_snapshot    = true
  # Multi-AZ
  # availability_zones        = local.azs
  availability_zones     = ["${split(",", local.azs)}"]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier          = "muaurorainstance"
  cluster_identifier  = aws_rds_cluster.aurorards.id
  instance_class      = "db.t3.small"
  engine              = aws_rds_cluster.aurorards.engine
  engine_version      = aws_rds_cluster.aurorards.engine_version
  publicly_accessible = true
}


