resource "aws_route_table" "portainer_rt" {
  vpc_id = aws_vpc.portainer_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.portainer_igw.id
  }

  tags = {
    Name = "portainer_rt"
  }
}

# Criação da Rota Default para Acesso à Internet
resource "aws_route" "portainer_routetointernet" {
  route_table_id            = aws_route_table.portainer_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.portainer_igw.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "portainer_pub_association" {
  subnet_id      = aws_subnet.portainer_subnet.id
  route_table_id = aws_route_table.portainer_rt.id
}