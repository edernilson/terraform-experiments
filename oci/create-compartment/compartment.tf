
resource "oci_identity_compartment" "tf-compartment" {
    # Required
    compartment_id = var.tenancy_ocid
    description = "Compartment for Terraform resources."
    name = "portainer_compartment"

    enable_delete = true

    timeouts {
        delete = "2h"
    }
}