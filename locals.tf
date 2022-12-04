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

  /* ec2_user_data = <<EOF
#!/bin/bash
amazon-linux-extras enable docker
yum install -y docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
echo "Docker started"
EOF */
  ec2_user_data = <<EOF
#! /bin/sh
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
docker pull ${var.docker_image_url}
docker create ${var.docker_image_url}
EOF
}