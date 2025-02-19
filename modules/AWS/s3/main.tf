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


# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "s3-bucket-mcloud-showcase" {
  bucket = "${var.bucket_name}-${random_uuid.uuid.result}"
}

resource "random_uuid" "uuid" {}

data "aws_s3_bucket" "selected-bucket" {
  bucket = aws_s3_bucket.s3-bucket-mcloud-showcase.bucket
}

resource "aws_s3_bucket_public_access_block" "s3-mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "s3-versioning_mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "s3-bucket-policy-mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  policy = data.aws_iam_policy_document.s3-iam-policy-mcloud-showcase.json
}

data "aws_iam_policy_document" "s3-iam-policy-mcloud-showcase" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.bucket_name}-${random_uuid.uuid.result}",
      "arn:aws:s3:::${var.bucket_name}-${random_uuid.uuid.result}/*",
    ]
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.s3-mcloud-showcase]
}
