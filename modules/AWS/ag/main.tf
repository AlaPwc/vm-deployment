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


variable "lambda_exec" {
  type    = string
  default = "example-role"
}

terraform import module.iam_roles.aws_iam_role.role_name lambda_exec
