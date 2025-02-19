resource "random_id" "bucket_suffix" {
  byte_length = 4 # Generates a random suffix
}

provider "google" {
  #credentials = file("gcp-key.json")
  project = var.project_id
  region  = var.region
}
# Generate a timestamp
resource "time_static" "timestamp" {}


resource "google_storage_bucket" "my_bucket" {
  name          = "${var.bucket_prefix}-${formatdate("YYYYMMDD", time_static.timestamp.rfc3339)}-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = var.storage_class
  force_destroy = true # Set to false to prevent accidental deletion

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365 # Auto-delete objects older than 1 year
    }
  }

  uniform_bucket_level_access = true # Recommended for security

  labels = {
    environment = "dev"
    owner       = "terraform"
  }
}
