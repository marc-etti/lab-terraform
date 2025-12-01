variable "location" {
  type    = string
  default = "switzerlandnorth"
}

variable "vm_name" {
  type    = string
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  type = string
}

variable "subscription_id" {
  type = string
}

# Azure service principal credentials

variable "appId" {}
variable "displayName" {}
variable "password" {}
variable "tenant" {}