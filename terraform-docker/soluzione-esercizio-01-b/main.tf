# Il bolocco terraform e provider sono stati spostati in providers.tf

# Immagine Docker di Nginx
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Container Docker che esegue Nginx
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080
  }
}