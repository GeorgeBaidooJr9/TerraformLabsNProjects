terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}
provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}