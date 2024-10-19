resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_subnet" "public_subnet01" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
 
  tags = {
    Name = "dev-public"
  }
}

resource "aws_subnet" "private_subnet01" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev-private01"
  }
}

resource "aws_subnet" "private_subnet02" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "dev-private02"
  }
}

resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dev-public"
  }
}

resource "aws_route_table" "dev-private-01" {
  vpc_id = aws_vpc.dev.id

  route = []

  tags = {
    Name = "dev-private-02"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet01.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private_subnet01.id
  route_table_id = aws_route_table.dev-private-01.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.private_subnet02.id
  route_table_id = aws_route_table.dev-private-01.id
}

resource "aws_security_group" "k8s" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev.id

  tags = {
    Name = "k8s-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "k8s-inbound-443" {
  security_group_id = aws_security_group.k8s.id
  cidr_ipv4         = aws_vpc.dev.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "k8s-inbound-80" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = aws_vpc.dev.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "k8s-outbound-all" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

