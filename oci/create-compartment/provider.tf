terraform {
    required_providers {
        oci = {
            source  = "hashicorp/oci"
            version = ">= 4.0.0"
        }
    }
}

provider "oci" {
    region = var.region
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    private_key_path = pathexpand(var.private_key_path)
    fingerprint = var.fingerprint
}