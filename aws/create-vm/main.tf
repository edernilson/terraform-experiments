data "aws_ami" "ubuntu22" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["amazon"] # Canonical
}

resource "aws_instance" "portainer_vm" {
  ami                         = "${data.aws_ami.ubuntu22.id}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.portainer_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.portainer_subnet.id
  key_name                    = aws_key_pair.portainer_keypair.key_name
  
  root_block_device {
    delete_on_termination = true
    volume_size           = 30
  }

  connection {
    type        = "ssh"
    user        = var.username
    host        = self.public_ip
    private_key = file(var.private_ssh_key)
  }

  # user_data = file("../dockerinstall.sh")
  provisioner "file" {
    source      = var.script_file
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

  depends_on = [
    aws_security_group.portainer_sg,
    aws_subnet.portainer_subnet,
    aws_key_pair.portainer_keypair
  ]

  tags = {
    Name = "portainer_vm"
  }
}


