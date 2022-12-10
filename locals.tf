locals {
  sg_ingress = concat(
    [
      {
        description = "Allow all HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        description = "Allow all HTTPS traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = "0.0.0.0/0"
      }
    ],
    [for ip in var.ssh_allowed_ips :
      {
        description = "IP-restricted SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = "${ip}/32"
      }
    ]
  )

  sg_egress = [
    {
      # TODO: see if SSH, HTTP & HTTPS can be enough eventually
      description = "Allow all egress traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ec2_user_data = templatefile("ec2_user_data.sh.tftpl",
    {
      docker_username               = var.docker_username
      docker_auth_token             = var.docker_auth_token
      docker_image_url              = var.docker_image_url
      docker_image_name             = var.docker_image_name
      secret_files_folder_ec2       = var.secret_files_folder_ec2
      secret_file_paths             = var.secret_file_paths
      secret_files_folder_container = var.secret_files_folder_container
  })
}