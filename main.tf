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

<<<<<<< HEAD
# ✅ Use existing security group (DO NOT create)
=======
# ✅ Use existing Security Group (no creation)
>>>>>>> 74dbdc8 (add dynamic API URL)
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["basic-sg"]
  }
}

<<<<<<< HEAD
# ✅ Create EC2 only
=======
# ✅ Create EC2 using existing resources
>>>>>>> 74dbdc8 (add dynamic API URL)
resource "aws_instance" "example" {
  ami           = "ami-080254318c2d8932f"
  instance_type = "t3.micro"

<<<<<<< HEAD
  key_name = "deployer-key"  # already exists
=======
  key_name = "deployer-key"  # existing key pair
>>>>>>> 74dbdc8 (add dynamic API URL)

  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "Terraform-Auto-VM"
  }
}

<<<<<<< HEAD
# ✅ Output public IP (useful later)
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
=======
# ✅ Output EC2 Public IP (useful for Jenkins later)
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
>>>>>>> 74dbdc8 (add dynamic API URL)
