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