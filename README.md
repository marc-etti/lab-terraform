# Laboratorio Terraform

## Comandi per l'esecuzione del laboratorio
1. Clonare il repository:
   ```bash
   git clone <repository-url>
   cd lab-terraform
   ```
2. Generare una chiave SSH (se non ne hai già una):
   ```bash
   ssh-keygen -t ed25519 -C "azure-terraform"
   ```
3. Rinominare il file `terraform.tfvars.sample` in `terraform.tfvars`:
    ```bash
    mv terraform.tfvars.sample terraform.tfvars
    ```
4. Aprire il file `terraform.tfvars`
    ```bash
    nano terraform.tfvars
    ```

4. Inserire la propria chiave pubblica SSH nel file `terraform.tfvars`, reperibile nel file `~/.ssh/azure-terraform.pub`: 
   ```bash
   ssh_public_key = "<your-ssh-public-key>"
   ```
5. Accedere ad Azure CLI:
   ```bash
   az login
   ```
6. Trovare l'ID della sottoscrizione:
   ```bash
   az account list --output table
   ```
7. Selezionare la sottoscrizione corretta:
   ```bash
   az account set --subscription "<your-subscription-id>"
   ```
8. Inizializzare Terraform:
   ```bash
   terraform init
   ```
9. Pianificare la distribuzione:
   ```bash
   terraform plan
   ```
10. Applicare la configurazione:
    ```bash
    terraform apply -auto-approve
    ```
11. Ottenere l'indirizzo IP pubblico della macchina virtuale:
    ```bash
    terraform output public_ip
    ```
12. Per connettersi alla macchina virtuale:
    ```bash
    ssh -i ~/.ssh/azure_terraform_key azureuser@<public-ip-address>
    ```
13. Al termine, per distruggere le risorse create:
    ```bash
    terraform destroy -auto-approve
    ```

## Dettagli della macchina virtuale creata
```
Macchina virtuale
Nome computer: AGE-Test-01
Sistema operativo: Linux (rocky 9.6)
Generazione macchina virtuale: V2
Architettura della macchina virtuale: x64
Stato agente: Ready
```