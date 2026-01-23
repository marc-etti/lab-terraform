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

output "php_app_http_url" {
  description = "URL per accedere all'applicazione web PHP dal browser"
  value       = "http://localhost:${docker_container.php_app.ports[1].external}"
}

output "php_app_ssh_connection" {
  description = "Comando SSH per accedere al container PHP"
  value       = "ssh root@localhost -p ${docker_container.php_app.ports[0].external}"
}

output "mariadb_ssh_connection" {
  description = "Comando SSH per accedere al container MariaDB"
  value       = "ssh root@localhost -p ${docker_container.mariadb.ports[0].external}"
}

output "php_app_ports" {
  description = "Mappatura delle porte del container PHP"
  value       = docker_container.php_app.ports
}

output "mariadb_ports" {
  description = "Mappatura delle porte del container MariaDB"
  value       = docker_container.mariadb.ports
}