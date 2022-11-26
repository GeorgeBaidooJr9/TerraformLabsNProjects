#Creating a VPC with custom Public/Private subnets as well as an RDS MySQL Database

provider "aws" {
  region = local.region
}

locals {
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"
  region = "us-east-1" 
  }


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-tough-vpc"
  cidr = "10.0.0.0/16"

 #Establishing different AZS and associating them with public/private subnets 
  azs             = ["us-east-1a", "us-east-1b"] 
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  tags = {
    Terraform ="true"
    Environment = "free tier"
  }

  public_subnet_tags = {
    Name = "amazing-public-subnets"
  }
  private_subnet_tags = {
    Name = "private-amazing-subnets"
  }

  vpc_tags = {
    Name = "terraform-tough-vpc"
  }
}
  
  #Creates an AWS MySQL database with set configuration
resource "aws_db_instance" "default" {
    allocated_storage    = 20
    db_name              = "mysql_4_terraform"
    engine               = "mysql"
    engine_version       = "8.0.28"
    instance_class       = "db.t3.micro"
    username             = "orbit-world"
    password             = "foozhead22"
    parameter_group_name = "default.mysql8.0.23"
    skip_final_snapshot  = true
    }
