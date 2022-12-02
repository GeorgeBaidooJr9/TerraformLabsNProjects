terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

#Creates AWS Linux EC2 Instance
resource "aws_instance" "app_server" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  key_name               = "lukey"
  monitoring             = true
  vpc_security_group_ids = ["sg-0a967d94600bc0405"]

  tags = {
    Name = "Week21Terraform-1"
    
    #Userdata in AWS EC2 using Terraform module. This is the bootstrap!
    user_data = file("script.sh")
  }
}