resource "null_resource" "remote-exec" {
  depends_on = [ oci_core_instance.ubuntu_instance ]

  provisioner "file" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${oci_core_instance.ubuntu_instance.public_ip}"
      user        = "${var.username}"
      private_key = file(var.private_ssh_key)
    }
    source      = var.script_file
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${oci_core_instance.ubuntu_instance.public_ip}"
      user        = "${var.username}"
      private_key = file(var.private_ssh_key)
    }
  
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  } 
}