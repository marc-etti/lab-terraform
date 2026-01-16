# Laboratorio Terraform con Docker
Importante: Ogni esercizio va svolto in una directory separata.


## Esercizio 1.a: Creazione di un Container Docker con Terraform
In questo esercizio, si richiede di creare un file di configurazione Terraform `main.tf` per eseguire un container Docker che esegue Nginx.
Suggerimenti:
- Utilizzare il provider Docker per Terraform.
  Attenzione: Usare la versione `3.6.1` del provider Docker.
- Definire una risorsa per l'immagine Docker di Nginx.
  - Usare l'immagine `nginx:latest`.
  - Impostare `keep_locally` su `false` per evitare di mantenere l'immagine localmente dopo la rimozione del container.
- Definire una risorsa per il container Docker che esegue l'immagine di Nginx.
  - Mappare la porta interna `80` alla porta esterna `8080`.
- Dopo aver creato il file `main.tf`, eseguire i comandi Terraform per inizializzare, pianificare e applicare la configurazione.
    - Comandi da eseguire:
        ```bash
        terraform init
        terraform plan
        terraform apply
        ```
- Verificare che il container Docker sia in esecuzione. Usare il comando `docker ps` per elencare i container in esecuzione.
- Verificare che Nginx sia accessibile aprendo un browser web e navigando all'indirizzo `http://localhost:8080`.
  o curl http://localhost:8080
- Infine, distruggere le risorse create con Terraform.
  - Comando da eseguire:
    ```bash
    terraform destroy
    ```

## Esercizio 1.b: Utilizzo di Providers, Variables e Outputs
In questo esercizio, si richiede di modificare la configurazione per utilizzare variabili e output.
- Creare un file `providers.tf` per definire il provider Docker con la versione `3.6.1`.
- Creare un file `variables.tf` per definire una variabile `container_name` con un valore predefinito di `ExampleNginxContainer`.
- Modificare il file `main.tf`:
  - Rimuovere la definizione del provider Docker (ora definita in `providers.tf`).
  - Modificare il nome del container utilizzando la variabile `container_name`.
- Creare un file `outputs.tf` per definire un output che visualizza l'ID del container Docker.
- Eseguire i comandi Terraform per inizializzare, pianificare e applicare la configurazione.
- Verificare che il container Docker sia in esecuzione con il nome specificato dalla variabile `container_name`.
  - Usare il comando `docker ps`. L'ultima colonna dovrebbe mostrare il nome del container.
- Visualizzare l'output definito nel file `outputs.tf` utilizzando il comando:
  ```bash
  terraform output
  ```
- Infine, distruggere le risorse create con Terraform.


## Esercizio 2.a: Terraform + Docker + Ansible
In questo esercizio, si richiede di utilizzare Terraform per eseguire un container Docker che sia predisposto per essere gestito da Ansible.
- Creare un file di configurazione Terraform `main.tf` per eseguire un container Docker con le seguenti specifiche:
    - Immagine di base di ubuntu: `ubuntu:latest`
    - Nome del container: `ubuntu-ansible`
    - Configurare le porte per esporre la porta SSH (22) del container. (Mappare la porta 2222 dell'host alla porta 22 del container)
    - Usare il seguente comando all'avvio del container per installare OpenSSH Server, Python3, avviare il servizio SSH e configurare l'accesso root con password `rootpassword`:
      ```hcl
      command = [
        "/bin/bash",
        "-c",
        <<-EOT
            apt-get update &&
            apt-get install -y openssh-server python3 &&
            mkdir /var/run/sshd &&
            echo 'root:rootpassword' | chpasswd &&
            sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
            /usr/sbin/sshd -D
        EOT
      ]
      ```
- Creare un file outputs.tf per visualizzare informazioni utili per connettersi al container (ad esempio, l'indirizzo IP)
- Dopo aver creato i file, eseguire i comandi Terraform per inizializzare, pianificare e applicare la configurazione.
- Verificare che il container Docker sia in esecuzione. Usare il comando `docker ps` per elencare i container in esecuzione.
- Verificare che sia possibile connettersi al container Docker tramite SSH.
  ```bash
  ssh root@localhost -p 2222
  # Password: rootpassword
  ```
- Creare un file di inventario Ansible per connettersi al container Docker.
  `inventory.ini`:
  ```ini
  [docker_containers]
  container_ansible ansible_host=localhost ansible_port=2222 ansible_user=root ansible_password=rootpassword ansible_connection=ssh ansible_python_interpreter=/usr/bin/python3 ansible_password=rootpassword ansible_connection=ssh ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
  ```
- Creare un playbook Ansible `playbook.yml` per eseguire un semplice comando di test.
  `playbook.yml`:
  ```yaml
  - name: Test connection to Docker container
    hosts: docker_containers
    gather_facts: false
    tasks:
      - name: Ping the container
        ping:
  ```
- Eseguire il playbook Ansible per verificare la connessione al container Docker:
  ```bash
  ansible-playbook -i inventory.ini playbook.yml
  ```
- Risultato atteso: Il playbook dovrebbe eseguire con successo il ping al container Docker:
  ```
  container_ansible | SUCCESS => {
    "ping": "pong"
  }
  ```
- Infine, distruggere le risorse create con Terraform.

## Esercizio 2.b: Deploy di un'Applicazione Web con Ansible
In questo esercizio si richiede di utilizzare Terraform per creare due container Docker: uno per il database MariaDB e uno per un'applicazione web basata su PHP che si connette al database.
- Creare un file di configurazione Terraform `main.tf` per la creazione di due container Docker:
    - Entrambi i container devono essere basati sull'immagine `ubuntu:latest`.
    - Entrambi i container devono essere configurati per esporre la porta SSH (22).
      - Mappare la porta 2222 dell'host alla porta 22 del container PHP.
      - Mappare la porta 2223 dell'host alla porta 22 del container MariaDB.
      - Configurare i container per installare OpenSSH Server e Python3 all'avvio, simile a quanto fatto nell' `esercizio 2.a`.
    - Il primo container esegue un'applicazione web PHP con le seguenti configurazioni:
        - Nome del container: `php_app_container`
        - Collegamento al container MariaDB.
        - Esposizione della porta 8080.
    - Il secondo container esegue MariaDB con le seguenti configurazioni:
        - Nome del container: `mariadb_container`
        - Variabile d'ambiente per la password di root: `MARIADB_ROOT_PASSWORD=my-secret-pw`
        - Esposizione della porta 3306.
- Creare un file outputs.tf per visualizzare le porte esposte dai container.
- Dopo aver creato i file, eseguire i comandi Terraform per inizializzare, pianificare e applicare la configurazione.
- Verificare che i container Docker siano in esecuzione. Usare il comando `docker ps` per elencare i container in esecuzione.
- Usare il playbook Ansible `webapp-playbook.yml` e l'inventario ` per configurare presenti nella cartella `ansible/`.
- Eseguire il playbook Ansible per distribuire l'applicazione web:
  ```bash
  ansible-playbook -i ansible/inventory.ini ansible/webapp-playbook.yml
  ```
- Verificare che l'applicazione web sia accessibile aprendo un browser web e navigando all'indirizzo `http://localhost:8080`.
- Infine, distruggere le risorse create con Terraform.

