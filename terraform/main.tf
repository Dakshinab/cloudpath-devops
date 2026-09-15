terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "cloudpath_image" {
  name = "cloudpath-app:latest"
}

resource "docker_container" "cloudpath_container" {
  name  = "cloudpath-terraform-container"
  image = docker_image.cloudpath_image.image_id
  ports {
    internal = 8080
    external = 8081
  }
}
