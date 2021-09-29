terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "aks-cluster" {
  source = "./modules/aks-cluster/"
  ssh_key = var.ssh_key
}

module "test-service" {
  source = "./modules/test-service/"
  host = "${module.aks-cluster.host}"
  client_certificate = "${base64decode(module.aks-cluster.client_certificate)}"
  client_key = "${base64decode(module.aks-cluster.client_key)}"
  cluster_ca_certificate = "${base64decode(module.aks-cluster.cluster_ca_certificate)}"
}