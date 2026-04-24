terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Use existing Security Group
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["basic-sg"]
  }
}

# Create EC2 using existing resources
resource "aws_instance" "example" {
  ami           = "ami-080254318c2d8932f"
  instance_type = "t3.micro"

  key_name = "deployer-key"

  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "Terraform-Auto-VM"
  }
}

# Output EC2 Public IP
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
