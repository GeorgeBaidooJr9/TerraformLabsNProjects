#Docker, ECS, ECR. 

data "aws_ecr_repository" "wk23-ecr-repo" {
  name = "wk23-ecr-repo"
}

resource "aws_ecs_cluster" "wk23-cluster" {
  name = "wk23-cluster"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "week-23-vpc" #name of the vpc
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1" #the first public subnet
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2" #the second public subnet
  }
}

resource "aws_ecs_service" "ecs-service-wk23" {
  name            = "ecs-service-wk23"
  cluster         = aws_ecs_cluster.wk23-cluster.id
  task_definition = aws_ecs_task_definition.task-4-week23-ecs.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}"]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "task-4-week23-ecs" {
  family                   = "task-4-week23-ecs"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "task-4-week23-ecs",
      "image": "${data.aws_ecr_repository.wk23-ecr-repo.repository_url}",
      "essential": true,
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
}

resource "aws_ecr_repository" "wk23-ecr-repo" {
  name = "wk23-ecr-repo"
}

resource "aws_ecr_repository_policy" "ecr-repo-policy" {
  repository = aws_ecr_repository.wk23-ecr-repo.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    ]
  }
  EOF
}

#Creates S3 bucket
resource "aws_s3_bucket" "my-test-23-bucket" {
  bucket = "my-test-23-bucket"

  tags = {
    Name        = "my-test-23-bucket"
    Environment = "Dev"
  }
}


 