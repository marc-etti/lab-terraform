output "container_ip" {
  description = "Indirizzo IP del container Docker"
  value       = docker_container.ansible_target.network_data[0].ip_address
}

output "ssh_port" {
  description = "Porta SSH esposta sull'host"
  value       = docker_container.ansible_target.ports[0].external
}