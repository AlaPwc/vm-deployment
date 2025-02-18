resource "aws_s3_bucket" "bucket-mcloud-showcase" {
  bucket = "${var.bucket_name}"
}

data "aws_s3_bucket" "selected-bucket" {
  bucket = aws_s3_bucket.mcloud-showcase.bucket
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership-mcloud-showcase]
}

resource "aws_s3_bucket_versioning" "versioning_mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership-mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.mcloud-showcase]
}

resource "aws_s3_bucket_public_access_block" "mcloud-showcase" {
  bucket = data.aws_s3_bucket.selected-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
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
      "arn:aws:s3:::www.${var.bucket_name}",
      "arn:aws:s3:::www.${var.bucket_name}/*",
    ]
actions = ["S3:GetObject"]
principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.mcloud-showcase]
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
    for_each        = fileset("uploads/", "*.html")
    bucket          = data.aws_s3_bucket.selected-bucket.bucket
    key             = each.value
    source          = "uploads/${each.value}"
    content_type    = "text/html"
    etag            = filemd5("uploads/${each.value}")
    acl             = "public-read"
}


