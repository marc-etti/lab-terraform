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