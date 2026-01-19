# Laboratorio Terraform - Azure
Importante: Ogni esercizio va svolto in una directory separata.



## Esercizio 1.a: Creazione di una Risorsa Azure con Terraform
In questo esercizio, configureremo Terraform per creare una Virtual Network e una Subnet in Azure all'interno di un Resource Group esistente chiamato `rg-agews-unife-course`.
Indicazioni:
- Utilizzare il provider Azure (azurerm) per Terraform.
  ```hcl
  terraform {
    required_version = ">= 1.10.0"

    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.0"
      }
    }
  }
  ```
- Configurare il provider Azure per usare la sottoscrizione specificata dalla variabile `subscription_id`.
  Per ottenere la `subscription_id` si usa ul comando Azure CLI:
  ```bash
  az account show
  ```json
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "...",
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", <-- Questa è la subscription_id
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantDefaultDomain": "agews.com",
    "tenantDisplayName": "AGE WEB SOLUTIONS S.R.L. A SOCIO UNICO",
    "tenantId": "...",
    "user": {
      "name": "mia_mail@mail.com",
      "type": "user"
    }
  }
  ```
- Creare una variabile `subscription_id` in un file `variables.tf`:
  ```hcl
  variable "subscription_id" {
    type = string
    description = "Azure subscription ID"
  }
- Creare il file `terraform.tfvars` per definire il valore della variabile `subscription_id`:
  ```hcl
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  ```
- Configurare il provider Azure nel file `main.tf`:
  ```hcl
  provider "azurerm" {
    features {}
    resource_provider_registrations = "none"
    subscription_id = var.subscription_id
  }
  ```
- In questo laboratorio creeremo risorse all'interno del Resource Group esistente chiamato `rg-agews-unife-course`.
  Definiamo quindi un data source per fare riferimento a questo Resource Group:
  ```hcl
  # Resource Group ESISTENTE (non viene creato da Terraform)
  data "azurerm_resource_group" "course_rg" {
    name = "rg-agews-unife-course"
  }
  ```
- Creare una risorsa di tipo Virtual Network (`azurerm_virtual_network`) con le seguenti specifiche:
  - Nome: `vnet-course`
  - Location: stessa del Resource Group esistente
  - Resource Group: `rg-agews-unife-course`
  - Address Space: `["10.0.0.0/16"]`
  ```hcl
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
  ```
- Creare una risorsa di tipo Subnet (`azurerm_subnet`) con le seguenti specifiche:
  - Nome: `subnet-course`
  - Resource Group: `rg-agews-unife-course`
  - Virtual Network: `vnet-course`
  - Address Prefix: `["10.0,1.0/24"]`
  ```hcl
  # Subnet
  resource "azurerm_subnet" "subnet" {
    name                 = "subnet-course"
    resource_group_name  = data.azurerm_resource_group.course_rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
  }
  ```
- Eseguire i comandi Terraform per inizializzare, pianificare e applicare la configurazione:
  ```bash
  terraform init
  terraform plan
  terraform apply
  ```
- Verificare la creazione delle risorse tramite il portale Azure o Azure CLI:
  ```bash
  az network vnet show --name vnet-course --resource-group rg-agews-unife-course
  az network vnet subnet show --name subnet-course --vnet-name vnet-course --resource-group rg-agews-unife-course
  ```
- Distruggere le risorse create con il comando:
  ```bash
  terraform destroy
  ```

## Esercizio 1.b:

