terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.1"
    }
  }
}

provider "docker" {}

# Immagine Docker di Nginx
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Container Docker che esegue Nginx
resource "docker_container" "nginx" {
  name  = "nginx-container"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080
  }
}