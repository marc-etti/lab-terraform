variable "location" {
  type    = string
  default = "switzerlandnorth"
  description = "Azure region where resources will be created"
}

variable "vm_name" {
  type    = string
  description = "Name of the virtual machine"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
  description = "Admin username for the virtual machine"
}

variable "ssh_public_key" {
  type = string
  description = "SSH public key for the virtual machine"
}

variable "subscription_id" {
  type = string
  description = "Azure subscription ID"
}

# Azure service principal credentials

variable "appId" {}
variable "displayName" {}
variable "password" {}
variable "tenant" {}