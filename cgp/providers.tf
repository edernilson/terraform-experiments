# terraform {
#   required_version = "~> 1.0"
#   required_providers {
#     google = {
#       source = "hashicorp/google"
#       version = "4.11.0"
#     }
#   }
# }

provider "google" {
  # credentials = file(var.gcp_auth_file)
  project = var.base_name
  region  = var.region
  zone    = var.zone
}