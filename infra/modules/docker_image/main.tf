terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}




resource "docker_registry_image" "hello_world" {

  name = "${var.repository}:${var.release_version}"
  build {
    context = "${path.module}/src"
    platform = "linux/arm64"
  }

  auth_config {
    address  = split("/",var.repository)[0]
    password = var.auth.password
    username = var.auth.user_name
  }
}