terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.31.0"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  default_tags {
    tags = var.default_tags
  }
}

# ============================= VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>3.18.1"

  name = "${var.app}-vpc"

  azs = var.vpc_azs
  cidr = var.vpc_cidr
  public_subnets = var.public_subnets

  create_igw = true
  map_public_ip_on_launch = true
}

# ============================= SG
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~>4.16.2"

  name = "${var.app}-sg-ec2"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = local.sg_ingress
  egress_with_cidr_blocks = local.sg_egress
}

# ============================= EC2
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~>4.2.1"

  name = "${var.app}-ec2"
  ami = data.aws_ami.amazon_linux_ami.image_id
  instance_type = var.ec2_instance_type

  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id = module.vpc.public_subnets[0]

  key_name = aws_key_pair.key_pair.key_name

  depends_on = [
    aws_key_pair.key_pair
  ]
}

# ============================= KEY PAIR
resource "aws_key_pair" "key_pair" {
  key_name = "${var.app}-ec2-key-pair"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# ============================= DYNAMIC AMI
data "aws_ami" "amazon_linux_ami" {
  most_recent = true

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

