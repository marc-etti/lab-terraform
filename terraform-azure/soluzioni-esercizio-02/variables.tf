variable "subscription_id" {
  type = string
  description = "Azure subscription ID"
}

variable "ssh_public_key" {
  type        = string
  description = "Chiave pubblica SSH (RSA) da installare sull'utente azureuser."
}

variable "suffix" {
  type        = string
  description = "Suffisso da aggiungere ai nomi delle risorse per renderli univoci."
  default     = "nome-cognome"
}