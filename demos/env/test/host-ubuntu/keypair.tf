# SPDX-License-Identifier: MIT

# Generate private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = "${var.project_name}-key-pair"
  }
}

# Save private key to local file
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${var.key_name}.pem"
  file_permission = "0400"
}
