resource "oci_core_instance" "ubuntu_instance" {
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.compartment_ocid
    shape = "VM.Standard.E2.1.Micro"
    source_details {
        source_id = var.image_source_ocid
        source_type = "image"
    }

    display_name = "${var.base_name}-ubuntu-instance"
    create_vnic_details {
        assign_private_dns_record = true
        assign_public_ip = true
        subnet_id = oci_core_subnet.vcn-public-subnet.id
    }
    metadata = {
        ssh_authorized_keys = file(var.public_ssh_key)
    } 
    preserve_boot_volume = false

    depends_on = [ 
        data.oci_identity_availability_domains.ads, 
        oci_core_subnet.vcn-public-subnet 
    ]
}