# SPDX-License-Identifier: MIT

# Outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "key_pair_name" {
  description = "Name of the created key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "private_key_filename" {
  description = "Filename of the private key"
  value       = local_file.private_key.filename
}

output "user_logs" {
  description = "SSH command to dump user script logs"
  value       = "ssh -i ${local_file.private_key.filename} ubuntu@${aws_instance.main.public_ip} cat /var/log/cloud-init-output.log"
}


output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${local_file.private_key.filename} ubuntu@${aws_instance.main.public_ip}"
}
