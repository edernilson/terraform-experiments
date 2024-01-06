resource "aws_security_group" "portainer_sg" {
  name = "${var.base_name}-sg"
  vpc_id = aws_vpc.portainer_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Portainer to EC2"
    protocol = "tcp"
    from_port = 9001
    to_port = 9001
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "portainer_sg"
  }
}