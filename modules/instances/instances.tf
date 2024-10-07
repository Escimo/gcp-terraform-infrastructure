resource "google_compute_instance" "tf-instance-1" {
  name         = "tf-instance-1"
  machine_type = "e2-standard-2"  # Replace with actual machine type
  zone         = var.zone
  tags         = ["web", "prod"] #Add a tags argument

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Replace with the actual boot disk image
    }
  }

  network_interface {
    network    = "tf-vpc-059284"        # Reference to the VPC
    subnetwork = "subnet-01"            # Connect to subnet-01
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
  EOT

  allow_stopping_for_update = true
}

resource "google_compute_instance" "tf-instance-2" {
  name         = "tf-instance-2"
  machine_type = "e2-standard-2"  # Replace with actual machine type
  zone         = var.zone
  tags         = ["web", "dev"] #Add a tags argument

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Replace with the actual boot disk image
    }
  }

  # Update the network and subnetwork for tf-instance-2
  network_interface {
    network    = "tf-vpc-059284"        # Reference to the VPC
    subnetwork = "subnet-02"            # Connect to subnet-02
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
  EOT

  allow_stopping_for_update = true
}