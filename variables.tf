variable "default_tags" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "app" {
  type = string
}

variable "ssh_allowed_ips" {
  type = list(string)
}

# ============================= VPC

variable "vpc_azs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

# ============================= EC2
variable "ec2_instance_type" {
  type = string
}

variable "pem_file_name" {
  type = string
}

# ============================= DOCKER CONFIG
variable "docker_image_url" {
  type = string
}