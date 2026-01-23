########################
# outputs.tf
########################

output "docker_network_name" {
  description = "Nome della rete Docker creata per l'applicazione"
  value       = docker_network.app_net.name
}

output "php_app_container_name" {
  description = "Nome del container che ospita l'applicazione PHP"
  value       = docker_container.php_app.name
}

output "mariadb_container_name" {
  description = "Nome del container che ospita MariaDB"
  value       = docker_container.mariadb.name
}