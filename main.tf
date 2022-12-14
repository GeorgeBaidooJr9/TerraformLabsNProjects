#Creating a VPC with custom Public/Private subnets, EC2 instances as well as an RDS MySQL Database

provider "aws" {
  region = "us-east-1"
}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "22terraform-vpc"
  cidr = "10.0.0.0/16"

 #Establishing different AZS and associating them with public/private subnets 
  azs             = ["us-east-1a", "us-east-1b"] 
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"] #private subnets for Web Tier
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.5.0/24", "10.0.6.0/24"] #private subnets for DB Tier

  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  tags = {
    Terraform ="true"
    Environment = "free tier"
  }

  public_subnet_tags = {
    Name = "public-subnets"
  }
  private_subnet_tags = {
    Name = "private-webtier-subnets"
  }
  database_subnet_tags = {
    Name = "private-dbtier-subnets"
  }

  vpc_tags = {
    Name = "22terraform-vpc"
  }
}

  
  #Creates an AWS MySQL database with set configuration
resource "aws_db_instance" "default"{
    allocated_storage    = 20
    db_name              = "mysql_4_terraform"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    username             = "orbitworld11"
    password             = "foozhead22"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
    }

#Creating EC2 instances on a public subnet 
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two"])

  name = "terra-instance-${each.key}"

  ami                    = "ami-0b0dcb5067f052a63"
  instance_type          = "t2.micro"
  key_name               = "lukey"
  monitoring             = true
  vpc_security_group_ids = ["sg-06811e76fd8d88ef0"]
  subnet_id              = "subnet-0a21dbfc65340945e"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#Creating a load balancer for public subnets
module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb-4-terraform"

  subnets         = ["subnet-0a21dbfc65340945e", "subnet-011c2265d2e318073"]
  security_groups = ["sg-06811e76fd8d88ef0"]
  internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = 8080
      instance_protocol = "http"
      lb_port           = 8080
      lb_protocol       = "http"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
  
  
}

 
