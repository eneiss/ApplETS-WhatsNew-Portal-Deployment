output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_private_key" {
  value = tls_private_key.private_key.private_key_pem
  sensitive = true
}

output "save_pem" {
  value = "cat terraform.tfstate |jq -r .outputs.ssh_private_key.value > ec2_key.pem && chmod 400 ec2_key.pem"
}

output "ec2_ssh_cmd" {
  value = "ssh ec2-user@${module.ec2.public_ip} -i ec2_key.pem"
}