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
variable "docker_username" {
  type = string
}

variable "docker_auth_token" {
  type = string
}

variable "docker_image_url" {
  type = string
}

variable "docker_image_name" {
  type = string
}

variable "secret_files_folder_ec2" {
  type = string
}

variable "secret_file_paths" {
  type = list(string)
}

variable "secret_files_folder_container" {
  type = string
}

# ============================= TESTING
variable "test_endpoint_port" {
  type = string
}

variable "test_endpoint_path" {
  type = string
}