terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "ap-south-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create Security Group
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2-security-group"
  description = "Allow SSH access on port 22"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Monitoring-server-security-group"
  }
}

# Create EC2 Instance
resource "aws_instance" "monitoring_server" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "c7i-flex.large"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = var.key_name

  tags = {
    Name = var.instance_name
  }
}