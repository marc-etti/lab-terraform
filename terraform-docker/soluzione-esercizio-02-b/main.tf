terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_net" {
  name = "app_net"
}

# Image Ubuntu
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

########################
# MariaDB container
########################
resource "docker_container" "mariadb" {
  name  = "mariadb_container"
  image = docker_image.ubuntu.image_id

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 22
    external = 2223
  }

  command = [
    "/bin/bash",
    "-c",
    <<-EOT
      apt-get update &&
      apt-get install -y openssh-server python3 python3-apt apt-utils &&
      mkdir /var/run/sshd &&
      echo 'root:rootpassword' | chpasswd &&
      sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
      /usr/sbin/sshd -D
    EOT
  ]
}

########################
# PHP Web App container
########################
resource "docker_container" "php_app" {
  name  = "php_app_container"
  image = docker_image.ubuntu.image_id

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 22
    external = 2222
  }

  ports {
    internal = 80
    external = 80
  }

  command = [
    "/bin/bash",
    "-c",
    <<-EOT
      apt-get update &&
      apt-get install -y openssh-server python3 python3-apt apt-utils &&
      mkdir /var/run/sshd &&
      echo 'root:rootpassword' | chpasswd &&
      sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
      /usr/sbin/sshd -D
    EOT
  ]

  depends_on = [docker_container.mariadb]
}