
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.23.1"
    }
  }
}

resource "docker_image" "docker-centos-image" {
  name = "centos:latest"
  keep_locally = false
}

resource "aws_ecr_repository" "wk23-ecr-repo-2" {
  name = "wk23-ecr-repo"
}
