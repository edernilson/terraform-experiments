resource "aws_subnet" "portainer_subnet" {
  vpc_id     = aws_vpc.portainer_vpc.id
  cidr_block = "10.0.1.0/24"
#   availability_zone = var.region

  tags = {
    Name = "portainer_subnet"
  }
}