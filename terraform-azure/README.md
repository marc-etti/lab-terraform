# Laboratorio Terraform - Azure
Importante: Ogni esercizio va svolto in una directory separata.

### Link utili:
- [Documentazione Ufficiale Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
  - [Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
  - [Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
  - [Linux Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
  - [Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
  - [Network Security Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
  - [Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)

## Esercizio 1: Creazione di una Risorsa Azure con Terraform
In questo esercizio, configureremo Terraform per creare una Virtual Network e una Subnet in Azure all'interno di un Resource Group esistente chiamato `rg-agews-unife-training`.
### Indicazioni:
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
  ```
  L'output sarà simile al seguente:
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
    "tenantDisplayName": "AGE WEB SOLUTIONS ... ",
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
- In questo laboratorio creeremo risorse all'interno del Resource Group esistente chiamato `rg-agews-unife-training`.
  Definiamo quindi un data source per fare riferimento a questo Resource Group:
  ```hcl
  # Resource Group ESISTENTE (non viene creato da Terraform)
  data "azurerm_resource_group" "course_rg" {
    name = "rg-agews-unife-training"
  }
  ```
- Creare una risorsa di tipo Virtual Network (`azurerm_virtual_network`) con le seguenti specifiche:
  - Nome: `vnet-course-nome-cognome`
  - Location: stessa del Resource Group esistente
  - Resource Group: `rg-agews-unife-training`
  - Address Space: `["10.0.0.0/16"]`
  ```hcl
  # Virtual Network
  resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-course-nome-cognome"
    location            = data.azurerm_resource_group.course_rg.location
    resource_group_name = data.azurerm_resource_group.course_rg.name
    address_space       = ["10.0.0.0/16"]

    tags = {
      course = "terraform-azure"
    }
  }
  ```
- Creare una risorsa di tipo Subnet (`azurerm_subnet`) con le seguenti specifiche:
  - Nome: `subnet-course-nome-cognome`
  - Resource Group: `rg-agews-unife-training`
  - Virtual Network: `vnet-course-nome-cognome`
  - Address Prefix: `["10.0.1.0/24"]`
  ```hcl
  # Subnet
  resource "azurerm_subnet" "subnet" {
    name                 = "subnet-course-nome-cognome"
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
  az network vnet show --name vnet-course-nome-cognome --resource-group rg-agews-unife-training
  az network vnet subnet show --name subnet-course-nome-cognome --vnet-name vnet-course-nome-cognome --resource-group rg-agews-unife-training
  ```
- Distruggere le risorse create con il comando:
  ```bash
  terraform destroy
  ```

## Esercizio 2: Creazione di una VM in Azure con Terraform

In questo esercizio useremo Terraform per creare una VM Linux Ubuntu 22.04 LTS (con accesso SSH) in Azure, all’interno di un Resource Group esistente.
Verranno create anche le risorse di rete necessarie: Virtual Network, Subnet, Public IP, Network Security Group (regola SSH), Network Interface.
Importante: svolgere l’esercizio in una directory separata (es. esercizio-2/).
Obiettivo
- Creare una VM Ubuntu con:
- IP pubblico statico
- Accesso SSH (porta 22) consentito in ingresso
- Login tramite chiave SSH (password disabilitata)
- Dimensione VM: Standard_B1s
- Ubuntu 22.04 LTS Gen2 (immagine Canonical)
- Cloud-init per installare python3 e configurare sudo senza password (utile per Ansible)

### Indicazioni:
- File `main.tf`
  Utilizzare il provider Azure (azurerm) per Terraform:
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
  Configurare il provider Azure per usare la sottoscrizione specificata dalla variabile subscription_id:
  ```hcl
  provider "azurerm" {
    features {}
    resource_provider_registrations = "none"
    subscription_id                 = var.subscription_id
  }
  ```
- Resource Group esistente (data source)

  Le risorse non creano il Resource Group: Terraform deve solo “agganciarlo”.
  ```hcl
  data "azurerm_resource_group" "course_rg" {
    name = "rg-agews-unife-training"
  }
  ```
- Creare un file `variables.tf` con le seguenti variabili:
  ```hcl
  variable "subscription_id" {
    type        = string
    description = "Azure subscription ID"
  }
  variable "suffix" {
    type        = string
    description = "Suffisso univoco per i nomi delle risorse (es: nome-cognome)"
  }
  variable "ssh_public_key" {
    type        = string
    description = "Chiave pubblica SSH per l'utente admin della VM"
  }
  ```
- Creare il file `terraform.tfvars` per definire i valori delle variabili:
  ```hcl
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  suffix          = "nome-cognome"
  ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... tuo_commento"
  ```

  Per ottenere la subscription_id:
  ```bash
  az account show
  ```
### Chiavi SSH
-  Per ottenere una coppia di chiavi SSH (se non le avete già), usare:
    ```bash
    ssh-keygen -t ed25519 -C "nome.cognome"
    ```
  - Chiave pubblica di default in `~/.ssh/id_ed25519.pub`.
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```
  - Chiave privata di default in `~/.ssh/id_ed25519`.
    ```bash
    cat ~/.ssh/id_ed25519
    ```


### Risorse da creare:
Nel file main.tf, implementare le seguenti risorse:
- Virtual Network
  - Nome: vnet-westeurope-${var.suffix}
  - Address space: 10.0.0.0/16
- Subnet
  - Nome: snet-westeurope-1-${var.suffix}
  - Prefix: 10.0.1.0/24
- Public IP (Static, Standard, zona 1)
  - Nome: Ubuntu-2204-ip-${var.suffix}
- Network Security Group con regola inbound SSH (porta 22)
  - Nome: nsg-Ubuntu-2204-${var.suffix}
- Network Interface (NIC) collegata a subnet + public ip
  - Nome: nic-Ubuntu-2204-${var.suffix}
- Associazione NIC - NSG
- Linux VM Ubuntu 22.04 LTS (Gen2)
  - Nome: Ubuntu-2204-${var.suffix}
  - Size: Standard_B1s
  - Zona: 1
  - Admin user: azureuser
  - Autenticazione: solo SSH key (password disabilitata)
  - OS Disk: Premium_LRS
  - custom_data con cloud-init per installare python3 e configurare sudo NOPASSWD

### Comandi Terraform

Eseguire i comandi nella directory dell’esercizio:
```bash
terraform init
terraform plan
terraform apply
```
### Verifica con Azure CLI

Verificare le risorse create (adatta i nomi con il tuo suffix):
```bash
az vm show \
  --name Ubuntu-2204-nome-cognome \
  --resource-group rg-agews-unife-training \
  --show-details

az network public-ip show \
  --name Ubuntu-2204-ip-nome-cognome \
  --resource-group rg-agews-unife-training \
  --query ipAddress -o tsv
```

### Connessione SSH alla VM
Per verificare la connettività SSH (dopo aver recuperato l’IP pubblico):
```bash
ssh -i ~/.ssh/<NOME_CHIAVE_PRIVATA> azureuser@<IP_PUBBLICO>
```

### Utilizzo di Ansible
creare un file `inventory.ini` con il seguente contenuto (adatta con il tuo IP pubblico):
```ini
[vm]
vm1 ansible_host=<IP_PUBBLICO> ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/<PRIVATE_KEY_FILE>
```
Dove:
- `<IP_PUBBLICO>` è l’indirizzo IP pubblico della VM (recuperato dall'output di `terraform apply`)
- `<PRIVATE_KEY_FILE>` è il file della chiave privata SSH corrispondente alla chiave pubblica usata per creare la VM. Solitamente è `~/.ssh/id_ed25519` o `~/.ssh/id_rsa`.

Eseguire un ping con Ansible per verificare la connettività:
```bash
ansible -i inventory.ini vm -m ping
```

creare un file `playbook.yml` con il seguente contenuto:
```yaml
---
- name: Check Ansible + update sistema (Ubuntu)
  hosts: vm
  become: true

  tasks:
    - name: Verifica connettivita' Ansible (ping)
      ansible.builtin.ping:

    - name: Raccoglie facts (verifica che funzioni la raccolta info)
      ansible.builtin.setup:

    - name: Mostra info principali
      ansible.builtin.debug:
        msg:
          - "Host: {{ inventory_hostname }}"
          - "OS: {{ ansible_distribution }} {{ ansible_distribution_version }}"
          - "Kernel: {{ ansible_kernel }}"
          - "IP: {{ ansible_default_ipv4.address | default('n/a') }}"

    - name: Aggiorna cache apt
      ansible.builtin.apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Aggiorna pacchetti (safe upgrade)
      ansible.builtin.apt:
        upgrade: safe

    - name: Rimuove dipendenze non piu' necessarie
      ansible.builtin.apt:
        autoremove: true

    - name: Pulisce cache apt
      ansible.builtin.apt:
        autoclean: true
```
Il playbook si occupa di:
- Verificare la connettività Ansible
- Raccogliere facts
- Mostrare alcune informazioni di sistema
- Aggiornare la cache di apt
- Eseguire un upgrade sicuro dei pacchetti
- Rimuovere dipendenze non più necessarie
- Pulire la cache di apt

Eseguire il playbook:
```bash
ansible-playbook -i inventory.ini playbook.yml
```
Verificare che tutte le operazioni siano andate a buon fine.

### Distruzione risorse

Al termine dell’esercizio:
```
terraform destroy
```

Per verificare che tutte le risorse siano state eliminate, usare Azure CLI:
```bash
az vm list --resource-group rg-agews-unife-training -o table
``` 
