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

module "security_group1" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  name        = "codesamplesg1"
  description = "Security group for codesample1"
  vpc_id      = var.vpc_id
  ingress_cidr_blocks = [var.ingress_cidr]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "security_group2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  name        = "codesamplesg2"
  description = "Security group for codesample2"
  vpc_id      = var.vpc_id
  ingress_cidr_blocks = [var.ingress_cidr]
  ingress_rules       = ["44444-tcp"]
  egress_rules        = ["all-all"]
}

module "ec2_instance" {
  for_each                    = module.ec2_instance.vpc_security_group_ids
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 2.0"
  name                        = "codesample1"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.security_group1, module.security_group2]
  associate_public_ip_address = true
}