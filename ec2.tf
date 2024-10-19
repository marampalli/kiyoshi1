resource "aws_instance" "k8s" {
  ami           = var.image_id
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.key_pair
  security_groups = aws_security_group.k8s.id
  subnet_id = aws_subnet.public_subnet01.id
  depends_on = [
    aws_security_group.k8s
  ]

  tags = {
    Name = "Kubernetes"
  }
}

