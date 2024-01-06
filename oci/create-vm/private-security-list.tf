# Source from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list

resource "oci_core_security_list" "private-security-list"{

# Required
  compartment_id = var.compartment_ocid
  vcn_id = module.vcn.vcn_id

# Optional
  display_name = "${var.base_name}-security-list-for-private-subnet"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  depends_on = [ module.vcn ]
}
