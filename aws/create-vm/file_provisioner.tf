resource "aws_key_pair" "portainer_keypair" {
  key_name   = "portainerkey"
  public_key = file(var.public_ssh_key)
}
