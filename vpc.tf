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