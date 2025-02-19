provider "google" {
  project = var.project_id
  region  = var.region
}

# Generate a unique random suffix for the VM instance name
resource "random_id" "vm_suffix" {
  byte_length = 2 # Generates a small random hex value
}

# Generate a timestamp
resource "time_static" "timestamp" {}



resource "google_compute_instance" "vm_instance" {
  name         = "${var.vm_instance_prefix}-${formatdate("YYYYMMDD", time_static.timestamp.rfc3339)}-${random_id.vm_suffix.hex}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250130" # Free-tier eligible image
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      echo "Hello, Terraform from GitHub Actions!" > /var/www/html/index.html
    EOT
  }
}
