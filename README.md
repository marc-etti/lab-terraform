# Laboratorio Terraform

## Operazioni preliminari
1. Assicurarsi di avere installato un client SSH. Su Linux, OpenSSH è solitamente preinstallato. Per verificare l'installazione, eseguire:
   ```bash
   ssh -V
   ```
2. Assicurarsi di avere installato [Terraform](https://developer.hashicorp.com/terraform/install#linux). Per verificare l'installazione, eseguire:
   ```bash
   terraform --version
   ```
3. Assicurarsi di avere installato [Azure CLI](https://learn.microsoft.com/it-it/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt). Per verificare l'installazione, eseguire:
   ```bash
   az --version
   ```
4. Eseguire il login ad Azure CLI:
   ```bash
   az login
   ```
   Si aprirà una pagina web per completare l'autenticazione.
5. Assicurarsi di vedere il resource group `rg-agews-unife-training` nella sezione: gruppi di risorse del portale Azure.


## Terraform + Docker
[README esercizi Terraform + Docker](terraform-docker/README.md)

## Terraform + Azure
[README esercizi Terraform + Azure](terraform-azure/README.md)