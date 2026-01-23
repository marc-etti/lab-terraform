########################
# variables.tf
########################

########################
# Variabili generali
########################
variable "docker_network_name" {
  description = "Nome della rete Docker per la comunicazione tra i container"
  type        = string
  default     = "app_net"
}

variable "ubuntu_image" {
  description = "Immagine Docker di base utilizzata per i container"
  type        = string
  default     = "ubuntu:latest"
}

########################
# Variabili container PHP
########################
variable "php_container_name" {
  description = "Nome del container dell'applicazione PHP"
  type        = string
  default     = "php_app_container"
}

variable "php_http_port" {
  description = "Porta HTTP esposta dall'host verso il container PHP"
  type        = number
  default     = 80
}

variable "php_ssh_port" {
  description = "Porta SSH esposta dall'host verso il container PHP"
  type        = number
  default     = 2222
}

########################
# Variabili container MariaDB
########################
variable "mariadb_container_name" {
  description = "Nome del container MariaDB"
  type        = string
  default     = "mariadb_container"
}

variable "mariadb_ssh_port" {
  description = "Porta SSH esposta dall'host verso il container MariaDB"
  type        = number
  default     = 2223
}

########################
# Variabili pacchetti da installare
########################
variable "install_base_packages" {
  description = "Lista dei pacchetti di base installati all'avvio dei container"
  type        = list(string)
  default = [
    "openssh-server",
    "python3",
    "python3-apt",
    "apt-utils"
  ]
}

variable "password_root_ssh" {
  description = "Password dell'utente root nei container"
  type        = string
  default     = "rootpassword"
}
