locals {
  sg_ingress = [
    {
      description = "IP-restricted SSH"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = "${var.ssh_ip}/32"
    },
    {
      description = "Allow all HTTP traffic"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "Allow all HTTPS traffic"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  sg_egress = [
    {
      # TODO: see if SSH, HTTP & HTTPS can be enough eventually
      description = "Allow all egress traffic"
      from_port = 0
      to_port = 0
      protocol = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}