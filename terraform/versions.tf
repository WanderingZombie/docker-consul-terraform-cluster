terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
    }
    docker = {
      source = "terraform-providers/docker"
    }
  }
  required_version = ">= 0.13"
}
