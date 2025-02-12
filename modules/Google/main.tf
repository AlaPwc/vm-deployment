provider "google" {
  #credentials = file("gcp-key.json")
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-github-action-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Free-tier eligible image
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
