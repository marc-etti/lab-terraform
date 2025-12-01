# --------------------------
# Resource Group
# --------------------------

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.vm_name}"
  location = var.location
}

# --------------------------
# Networking
# --------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-${var.location}-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# --------------------------
# Linux Virtual Machine
# --------------------------

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  zone                = "1"

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # OS Disk
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Image: Rocky Linux 9 (publisher resf)
  source_image_reference {
    publisher = "resf"
    offer     = "rockylinux-x86_64"
    sku       = "9-base"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # Trusted Launch → Secure Boot + vTPM
  secure_boot_enabled = true
  vtpm_enabled        = true

  # Tags
  tags = {
    environment = "lab"
    os          = "rocky9"
  }
}
