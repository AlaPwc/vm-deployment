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

resource "aws_s3_bucket" "bucket-mcloud-showcase" {
  bucket = "${var.bucket_name}-${random_uuid.uuid.result}"
}

resource "random_uuid" "uuid" {}

data "aws_s3_bucket" "selected-bucket" {
  bucket = aws_s3_bucket.bucket-mcloud-showcase.bucket
}

resource "aws_s3_bucket_public_access_block" "mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "versioning_mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket-policy-mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  policy = data.aws_iam_policy_document.iam-policy-mcloud-showcase.json
}

data "aws_iam_policy_document" "iam-policy-mcloud-showcase" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
resources = [
      "arn:aws:s3:::${var.bucket_name}-${random_uuid.uuid.result}",
      "arn:aws:s3:::${var.bucket_name}-${random_uuid.uuid.result}/*",
    ]
actions = [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:RestoreObject",
                "s3:ListBucketVersions",
                "s3:ListMultipartUploadParts",
                "s3:GetObjectAttributes",
                "s3:GetObjectVersion",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl"
            ]
principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  #depends_on = [aws_s3_bucket_public_access_block.mcloud-showcase]
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = data.aws_s3_bucket.selected-bucket.bucket
index_document {
    suffix = "index.html"
  }
error_document {
    key = "error.html"
  }
# IF you want to use the routing rule
routing_rule {
    condition {
      key_prefix_equals = "/abc"
    }
    redirect {
      replace_key_prefix_with = "comming-soon.jpeg"
    }
  }
}

resource "aws_s3_object" "object-upload-html" {
    for_each        = fileset("./", "*.html")
    bucket          = data.aws_s3_bucket.selected-bucket.bucket
    key             = each.value
    source          = "./${each.value}"
    content_type    = "text/html"
    etag            = filemd5("./${each.value}")
    #acl             = "public-read"
}


