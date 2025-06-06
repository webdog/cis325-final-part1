# Generate SSH Key Pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key locally
output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

# Save the public key for use in the EC2 instance
output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

# Use the public key in the EC2 instance
resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Security Group
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              docker pull ghcr.io/${var.ghcr_repo}/${var.ghcr_image}:latest
              docker run -d -p 80:80 ghcr.io/${var.ghcr_repo}/${var.ghcr_image}:latest
              EOF

  tags = {
    Name = var.instance_name
  }
}

# Write SSH private key to a local file
resource "local_file" "ssh_key_file" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/ssh_key.pem"
  file_permission = "0600"  # Secure permissions for SSH key
}