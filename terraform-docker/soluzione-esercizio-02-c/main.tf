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
  name = var.docker_network_name
}

# Image Ubuntu
resource "docker_image" "ubuntu" {
  name = var.ubuntu_image
}

########################
# MariaDB container
########################
resource "docker_container" "mariadb" {
  name  = var.mariadb_container_name
  image = docker_image.ubuntu.image_id

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 22
    external = var.mariadb_ssh_port
  }

  command = [
    "/bin/bash",
    "-c",
    <<-EOT
      apt-get update &&
      apt-get install -y ${join(" ",var.install_base_packages)} &&
      mkdir /var/run/sshd &&
      echo 'root:${var.password_root_ssh}' | chpasswd &&
      sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
      /usr/sbin/sshd -D
    EOT
  ]
}

########################
# PHP Web App container
########################
resource "docker_container" "php_app" {
  name  = var.php_container_name
  image = docker_image.ubuntu.image_id

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 22
    external = var.php_ssh_port
  }

  ports {
    internal = 80
    external = var.php_http_port
  }

  command = [
    "/bin/bash",
    "-c",
    <<-EOT
      apt-get update &&
      apt-get install -y ${join(" ",var.install_base_packages)} &&
      mkdir /var/run/sshd &&
      echo 'root:${var.password_root_ssh}' | chpasswd &&
      sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&
      /usr/sbin/sshd -D
    EOT
  ]

  depends_on = [docker_container.mariadb]
}