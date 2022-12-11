#Creating a VPC with custom Public/Private subnets, Auto-scaling group of EC2 instances, as well as an RDS MySQL Database

module "vpc" {

  name = "wk22-terraform-vpc"
  cidr = "10.0.0.0/16"

 #Establishing different AZS and associating them with public/private subnets 
  azs             = ["us-east-1a", "us-east-1b"] 
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] #Private subnets for Web Server & RDS Tier
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"] 

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
    Name = "private-WBTier-subnets"
  }

  vpc_tags = {
    Name = "wk22-terraform-vpc"
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

#Creating an Auto-scaling group of EC2 instances  
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  
  name = "wk22-instances"

  # Launch configuration
  lc_name = "wk22-instances-lc"

  image_id        = "ami-0b0dcb5067f052a63"
  instance_type   = "t2.micro"
  security_groups = ["sg-06811e76fd8d88ef0"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "autoscaling_wk22_terraform"
  vpc_zone_identifier       = ["subnet-0a21dbfc65340945e"]
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key_name                 = "lukey"
      propagate_at_launch = true
    },
  ]
}

#Creating a load balancer for public subnets
module "elb_http" {
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
  
#Creates Bastion Host
  resource "aws_launch_template" "Wk22_bastion" {
  name_prefix            = "Wk22_bastion"
  image_id               = data.aws_ami.linux.id
  instance_type          = var.bastion_instance_type
  vpc_security_group_ids = [var.public_sg]

  tags = {
    Name = "Wk22_bastion"
  }
}
}
 
  
 

 
