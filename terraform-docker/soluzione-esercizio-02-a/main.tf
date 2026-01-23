terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.1"
    }
  }
}

provider "docker" {}

# Immagine Ubuntu
resource "docker_image" "ubuntu" {
  name = "ubuntu:22.04"
}

# Container Ubuntu predisposto per Ansible
resource "docker_container" "ansible_target" {
  name  = "ubuntu-ansible"
  image = docker_image.ubuntu.image_id

  ports {
    internal = 22
    external = 2222
  }

  # Avvio SSH in foreground
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
}