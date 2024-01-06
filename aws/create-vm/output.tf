output "instance_ip" {
  value = aws_instance.portainer_vm.public_ip
}

output "image_id" {
    value = "${data.aws_ami.ubuntu22.id}"
}