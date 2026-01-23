output "nginx_container_id" {
  description = "ID del container Docker Nginx"
  value       = docker_container.nginx.id
}