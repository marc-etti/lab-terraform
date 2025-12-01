output "public_ip" {
  description = "Indirizzo IP pubblico assegnato alla VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "private_ip" {
  description = "Indirizzo IP privato della VM"
  value       = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

