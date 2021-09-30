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

# module "aks-cluster" {
#   source = "./azure/modules/aks-cluster/"
#   ssh_key = var.ssh_key
# }

module "gcp-project" {
  source = "./gcp/modules/project/"
  gcp_project_name = var.gcp_project_name
  gcp_project_id = var.gcp_project_id
  gcp_org_id = var.gcp_org_id
  gcp_billing_account = var.gcp_billing_account
  gcp_enable_apis = var.gcp_enable_apis
}

module "gke_cluster" {
  source = "./gcp/modules/gke-cluster/"
  gcp_project_id = var.gcp_project_id
  gcp_location = var.gcp_location
}

# module "test-service" {
#   source = "./modules/test-service/"
#   host = "${module.aks-cluster.host}"
#   client_certificate = "${base64decode(module.aks-cluster.client_certificate)}"
#   client_key = "${base64decode(module.aks-cluster.client_key)}"
#   cluster_ca_certificate = "${base64decode(module.aks-cluster.cluster_ca_certificate)}"
# }

