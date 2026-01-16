# Laboratorio Terraform

## Operazioni preliminari
1. Assicurarsi di avere installato un client SSH. Su Linux, OpenSSH è solitamente preinstallato. Per verificare l'installazione, eseguire:
   ```bash
   ssh -V
   ```
2. Assicurarsi di avere installato [Terraform](https://developer.hashicorp.com/terraform/install#linux). Per verificare l'installazione, eseguire:
   ```bash
   terraform -version
   ```
3. Assicurarsi di avere installato [Azure CLI](https://learn.microsoft.com/it-it/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt). Per verificare l'installazione, eseguire:
   ```bash
   az --version
   ```
4. Assicurarsi di avere un account Azure attivo. Se non si dispone di un account, è possibile crearne uno gratuitamente sul [portale Azure](https://azure.microsoft.com/it-it/get-started/azure-portal).
   Una volta creato l'account, prendere nota dell'ID della sottoscrizione.
   Ad esempio `Azure for Students`.


## Comandi per l'esecuzione del laboratorio
01. Clonare il repository:
    ```bash
    git clone <repository-url>
    cd lab-terraform
    ```
02. Generare una chiave SSH (se non ne hai già una):
    ```bash
    ssh-keygen -t ed25519 -C "azure-terraform"
    ```
03. Rinominare il file `terraform.tfvars.sample` in `terraform.tfvars`:
    ```bash
    mv terraform.tfvars.sample terraform.tfvars
    ```
04. Aprire il file `terraform.tfvars`
    ```bash
    nano terraform.tfvars
    ```

05. Inserire la propria chiave pubblica SSH nel file `terraform.tfvars`, reperibile nel file `~/.ssh/azure-terraform.pub`: 
    ```bash
    ssh_public_key = "<your-ssh-public-key>"
    ```
06. Accedere ad Azure CLI:
    ```bash
    az login
    ```
07. Trovare l'ID della sottoscrizione:
    ```bash
    az account list --output table
    ```
08. Selezionare la sottoscrizione corretta:
    ```bash
    az account set --subscription "<your-subscription-id>"
    ```
09. Ottenere le credenziali di azure `appID`, `tenantID`, `clientSecret` e `displayName`:
    ```bash
    az ad sp create-for-rbac --name "terraform-sp-$(date +%s)" \
        --role="Contributor" \
        --scopes="/subscriptions/<your-subscription-id>" \
    ```
    Inserire i valori ottenuti nel file `terraform.tfvars`:
    ```hcl
    subscription_id = "<your-subscription-id>"
    appId           = "<your-appID>"
    displayName     = "<your-displayName>"
    password        = "<your-password>"
    tenant          = "<your-tenantID>"
    ```
10. Inizializzare Terraform:
    ```bash
    terraform init
    ```
11. Pianificare la distribuzione:
    ```bash
    terraform plan
    ```
12. Applicare la configurazione:
    ```bash
    terraform apply -auto-approve
    ```
13. Ottenere l'indirizzo IP pubblico della macchina virtuale:
    ```bash
    terraform output public_ip
    ```
14. Per connettersi alla macchina virtuale:
    ```bash
    ssh -i ~/.ssh/azure_terraform_key azureuser@<public-ip-address>
    ```
    Se è la prima volta che ci si connette, potrebbe essere necessario accettare l'impronta digitale del server digitando `yes`. A questo punto si sarà connessi alla macchina virtuale creata su Azure.
    Per uscire dalla macchina virtuale, digitare `exit`.
15. Al termine, per distruggere le risorse create:
    ```bash
    terraform destroy -auto-approve
    ```
16. Controllare su [Azure](https://portal.azure.com) che tutte le risorse siano state eliminate correttamente.

## Dettagli della macchina virtuale creata
```
Macchina virtuale
Nome computer: AGE-Test-01
Sistema operativo: Linux (rocky 9.6)
Generazione macchina virtuale: V2
Architettura della macchina virtuale: x64
Stato agente: Ready
```