# OUTPUTS

output "ansible_user" {
  value = "azureuser"
}

output "public_ip_name" {
  value = azurerm_public_ip.pip.name
}

output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}