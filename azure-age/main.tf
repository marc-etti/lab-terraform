terraform {
  required_version = ">= 1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id = var.subscription_id
}
# Resource Group ESISTENTE (non viene creato da Terraform)
data "azurerm_resource_group" "course_rg" {
  name = "rg-agews-unife-course"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-course"
  location            = data.azurerm_resource_group.course_rg.location
  resource_group_name = data.azurerm_resource_group.course_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    course = "terraform-azure"
  }
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-course"
  resource_group_name  = data.azurerm_resource_group.course_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}