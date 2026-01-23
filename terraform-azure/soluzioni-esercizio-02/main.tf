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
  subscription_id                 = var.subscription_id
}

# RG ESISTENTE
data "azurerm_resource_group" "course_rg" {
  name = "rg-agews-unife-training"
  # name = "Gruppo-Test-01"
}

# NETWORK
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-westeurope-${var.suffix}"
  location            = data.azurerm_resource_group.course_rg.location
  resource_group_name = data.azurerm_resource_group.course_rg.name

  address_space = ["10.0.0.0/16"]

  tags = {
    course = "terraform-azure"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-westeurope-1-${var.suffix}"
  resource_group_name  = data.azurerm_resource_group.course_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]
}

# PUBLIC IP
resource "azurerm_public_ip" "pip" {
  name                = "Ubuntu-2204-ip-${var.suffix}"
  location            = data.azurerm_resource_group.course_rg.location
  resource_group_name = data.azurerm_resource_group.course_rg.name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = ["1"]

  tags = {
    course = "terraform-azure"
  }
}

# NSG (SSH inbound)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-Ubuntu-2204-${var.suffix}"
  location            = data.azurerm_resource_group.course_rg.location
  resource_group_name = data.azurerm_resource_group.course_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    course = "terraform-azure"
  }
}

# NIC
resource "azurerm_network_interface" "nic" {
  name                = "nic-Ubuntu-2204-${var.suffix}"
  location            = data.azurerm_resource_group.course_rg.location
  resource_group_name = data.azurerm_resource_group.course_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  tags = {
    course = "terraform-azure"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# VM LINUX (Ubuntu 22.04 LTS - x64 Gen2)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "Ubuntu-2204-${var.suffix}"
  location            = data.azurerm_resource_group.course_rg.location
  resource_group_name = data.azurerm_resource_group.course_rg.name

  size = "Standard_B1s"
  zone = "1"

  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # Ubuntu Server 22.04 LTS - x64 Gen2 (no plan required)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  # Cloud-init per "Ansible ready" (python3 + sudo NOPASSWD)
  custom_data = base64encode(<<CLOUDINIT
#cloud-config
package_update: true
packages:
  - python3

runcmd:
  - [ bash, -lc, "echo 'azureuser ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/90-azureuser-nopasswd" ]
  - [ bash, -lc, "chmod 440 /etc/sudoers.d/90-azureuser-nopasswd" ]
  - [ bash, -lc, "sed -i 's/^#\\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config || true" ]
  - [ bash, -lc, "systemctl restart ssh || systemctl restart sshd || true" ]
CLOUDINIT
  )

  tags = {
    course = "terraform-azure"
  }
}
