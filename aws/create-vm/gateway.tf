resource "aws_internet_gateway" "portainer_igw" {
  vpc_id = aws_vpc.portainer_vpc.id

  tags = {
    Name = "portainer_igw"
  }
}