provider "google" {
  #credentials = file("gcp-key.json")
  project = var.project_id
  region  = var.region
}

# Generate a unique random suffix for the DB instance name
resource "random_id" "db_suffix" {
  byte_length = 2 # Generates a small random hex value
}

# Generate a timestamp
resource "time_static" "timestamp" {}

resource "google_sql_database_instance" "db_instance" {
  name             = "${var.db_instance_prefix}-${formatdate("YYYYMMDD", time_static.timestamp.rfc3339)}-${random_id.db_suffix.hex}"
  region           = var.region
  database_version = var.db_version

  settings {
    tier              = var.db_tier # Machine type for the database
    availability_type = "ZONAL"     # Change to "REGIONAL" for high availability

    backup_configuration {
      enabled            = true
      binary_log_enabled = false
    }

    ip_configuration {
      ipv4_enabled = true # Set to false if using private IP only
      authorized_networks {
        name  = "allow-all"
        value = "0.0.0.0/0" # WARNING: Open to all. Restrict in production.
      }
    }
  }

  deletion_protection = false # Change to true to prevent accidental deletion
}

resource "google_sql_user" "db_user" {
  name     = var.db_username
  instance = google_sql_database_instance.db_instance.name
  password = var.db_password
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}
