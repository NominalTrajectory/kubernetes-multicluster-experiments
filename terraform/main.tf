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

provider "google" {
}

# AZURE MODULES

module "main-rg" {
  source = "./azure/modules/main-rg/"
  azure_location = var.azure_location
}

module "submariner-broker-cluster" {
  source = "./azure/modules/submariner-broker-cluster/"
  ssh_key = var.ssh_key
  azure_submariner_broker_location = var.azure_submariner_broker_location
  rg_name = "${module.main-rg.rg_name}"
}

module "aks-cluster" {
  source = "./azure/modules/aks-cluster/"
  ssh_key = var.ssh_key
  azure_location = var.azure_location
  rg_name = "${module.main-rg.rg_name}"
}

# module "test-service" {
#   source = "./azure/modules/test-service/"
#   host = "${module.aks-cluster.host}"
#   client_certificate = "${base64decode(module.aks-cluster.client_certificate)}"
#   client_key = "${base64decode(module.aks-cluster.client_key)}"
#   cluster_ca_certificate = "${base64decode(module.aks-cluster.cluster_ca_certificate)}"
# }


# GCP MODULES

# module "gcp-project" {
#   source = "./gcp/modules/project/"
#   gcp_project_name = var.gcp_project_name
#   gcp_project_id = var.gcp_project_id
#   gcp_org_id = var.gcp_org_id
#   gcp_billing_account = var.gcp_billing_account
#   gcp_enable_apis = var.gcp_enable_apis
# }

# module "gke_cluster" {
#   source = "./gcp/modules/gke-cluster/"
#   gcp_project_id = var.gcp_project_id
#   gcp_location = var.gcp_location
# }