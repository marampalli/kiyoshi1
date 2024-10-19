data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

    owners = ["137112412989"] # Canonical
}

resource "aws_instance" "k8s" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"

  tags = {
    Name = "Kubernetes"
  }
}