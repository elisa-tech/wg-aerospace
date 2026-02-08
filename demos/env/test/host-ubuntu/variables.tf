# SPDX-License-Identifier: MIT

# Variables
variable "enable_log_checker" {
  description = "Enable or disable the log checker"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "user_script" {
  description = "Test Script"
  type        = string
  default     = "test-normal-case.sh"
}

# variable "availability_zone" {
#   description = "Availability zone"
#   type        = string
#   default     = "us-east-1a"
# }

# For TESTING, make sure to match host and AMI architecture
#   (e.g., t4g for ARM64, t3a for x86_64)
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.small"
}

# See Arch note above in instance_type variable so this matches
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"
}

variable "key_name" {
  description = "Name for the key pair"
  type        = string
  default     = "my-ec2-key"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "arm64-aerowg-demo-test"
}
