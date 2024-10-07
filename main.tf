# Terraform block for specifying required providers and version constraints
terraform {
  required_version = ">= 0.13"  # Specify a minimum version of Terraform

  # Define the provider source and version for Google Cloud
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  # Backend configuration to store Terraform state (optional but recommended)
  backend "gcs" {
    bucket = "my-bucket-for-tfstate"  # Replace with your GCS bucket name
    prefix = "terraform/state"              # Directory in the bucket for state
  }
  #backend "local" {
  #  path = "terraform_project/state/terraform.tfstate"
  #}
}

# Google Cloud provider configuration
provider "google" {
  project = var.project_id  # Use the variable defined in variables.tf for project_id
  region  = var.region      # Use the variable defined in variables.tf for region
  zone    = var.zone        # Use the variable defined in variables.tf for zone
}

# Add the instances module to the main.tf
module "instances" {
  source      = "./modules/instances"
  project_id  = var.project_id
  region      = var.region
  zone        = var.zone
  # Pass the subnet self-links from the VPC module to the instances module
  subnet_01_self_link = module.vpc.subnets_self_links[0]  # Connect to subnet-01
  subnet_02_self_link = module.vpc.subnets_self_links[1]  # Connect to subnet-02

}

# Add the storage module to main.tf
module "storage" {
  source = "./modules/storage"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

# Add the network module from the Terraform registry
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "6.0.0"

  project_id   = var.project_id
  network_name = "tf-vpc-059284" # Name your network
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "us-west1"
    }
  ]
}

resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = module.vpc.network_self_link  # Using the self-link of the VPC created by the network module

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow connections from all IP ranges
  direction     = "INGRESS"
  target_tags   = ["http-server"]  # Optional: You can assign this to instances if needed.
}