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
  client_id       = var.appId
  client_secret   = var.password
  tenant_id       = var.tenant
  
  subscription_id = var.subscription_id
}