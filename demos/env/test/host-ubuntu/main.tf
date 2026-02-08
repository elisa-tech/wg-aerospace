# SPDX-License-Identifier: MIT

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_id]
  }
  owners = ["099720109477"] # Canonical owner ID for most regions
}

# 1. Define the IAM role's trust policy (assume role policy)
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# 2. Create the IAM role
resource "aws_iam_role" "example_role" {
  name               = "example-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# 3. (Optional) Attach a permissions policy to the role
# This example uses the AWS managed "AmazonSSMManagedInstanceCore" policy for basic functionality
resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 4. Create an IAM instance profile and associate the role with it
resource "aws_iam_instance_profile" "example_profile" {
  name = "example-profile"
  role = aws_iam_role.example_role.name
}

# EC2 Instance
resource "aws_instance" "main" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.example_profile.name

  metadata_options {
    http_tokens = "required"
  }

  user_data = file("${path.module}/${var.user_script}")

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 40
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  tags = {
    Name = "${var.project_name}-ec2-instance"
  }
  depends_on = [aws_security_group.ec2_sg]
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for EC2 instance"

  # SSH access from anywhere
  #
  # Ideas around restricting this
  #  - https://www.google.com/search?q=how+to+auto+gen+the+cidr_blocks+%3D+%5B%220.0.0.0%2F0%22%5D+for+ssh+inbound+at+terraform+apply&rlz=1CAANLP_enUS1091US1091&oq=how+to+auto+gen+the+cidr_blocks+%3D+%5B%220.0.0.0%2F0%22%5D+for+ssh+inbound+at+terraform+apply&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCTEyMjY1ajBqNKgCA7ACAfEF99H0otuk_Lw&sourceid=chrome&ie=UTF-8
  #tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TBD, should not do this and fix apt repos that fail when http->https
  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    description = "HTTP"
    from_port   = 0
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    description = "DNS TCP"
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    description = "DNS UDP"
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "null_resource" "log_checker" {
  count      = var.enable_log_checker ? 1 : 0
  depends_on = [aws_instance.main]

  triggers = {
    instance_id = aws_instance.main.id
  }

  # Connection details
  connection {
    type        = "ssh"
    user        = "ubuntu" # Change as needed for your AMI
    private_key = file(local_file.private_key.filename)
    host        = aws_instance.main.public_ip
  }

  # Use remote-exec to run the script on the instance
  provisioner "remote-exec" {
    inline = [
      "timeout 200 bash -c 'until grep -q \"Tests Completed Successfully.\" /var/log/cloud-init-output.log; do sleep 10; done' || { echo 'Timeout reached waiting for test completion'; tail -n 40 /var/log/cloud-init-output.log; exit 1; }"
    ]
  }
}
