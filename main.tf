data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.ami_search]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_security_group" "codesamplesg1" {
  description = "Security group for codesample1"
  vpc_id      = var.vpc_id
  ingress {
    description   = "HTTP"
    from_port     = "80"
    to_port       = "80"
    protocol      = "tcp"
    cidr_blocks   = [var.ingress_cidr]
  }
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = [var.egress_cidr]
  }
}

resource "aws_security_group" "codesamplesg2" {
  description = "Security group for codesample2"
  vpc_id      = var.vpc_id
  ingress {
    description   = "Only 44444"
    from_port     = "44444"
    to_port       = "44444"
    protocol      = "tcp"
    cidr_blocks   = [var.ingress_cidr]
  }
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = [var.egress_cidr]
  }
}

resource "aws_instance" "codesample1" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.codesamplesg1.id]
  associate_public_ip_address = true
}

resource "aws_instance" "codesample2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.codesamplesg2.id]
  associate_public_ip_address = true
}
