terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.78.0"
    }

    google ={
      source = "hashicorp/google"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "google" {
}

provider "aws" {
  region = var.aws_region
}

# AZURE MODULES

# module "main-rg" {
#   source = "./azure/modules/main-rg/"
#   azure_location = var.azure_location
# }

# module "submariner-broker-cluster" {
#   source = "./azure/modules/submariner-broker-cluster/"
#   ssh_key = var.ssh_key
#   azure_submariner_broker_location = var.azure_submariner_broker_location
#   rg_name = "${module.main-rg.rg_name}"
# }

# module "aks-cluster" {
#   source = "./azure/modules/aks-cluster/"
#   ssh_key = var.ssh_key
#   azure_location = var.azure_location
#   rg_name = "${module.main-rg.rg_name}"
# }

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

# module "gcp-network" {
#   source = "./gcp/modules/network/"
#   gcp_location = var.gcp_location
#   gcp_project_id = var.gcp_project_id
  
# }

# module "gke-cluster" {
#   source = "./gcp/modules/gke-cluster/"
#   gcp_project_id = var.gcp_project_id
#   gcp_location = var.gcp_location
#   subnet_self_link = "${module.gcp-network.subnet_self_link}"
# }

# AWS MODULES

module "aws-vpc" {
  source = "./aws/modules/vpc/"
}

module "aws-sgs" {
  source = "./aws/modules/sgs/"
  vpc_id = "${module.aws-vpc.vpc_id}"
  cidr_blocks = "${module.aws-vpc.private_subnets_cidr_blocks}"
}

module "eks-cluster" {
  source = "./aws/modules/eks-cluster/"
  vpc_id = "${module.aws-vpc.vpc_id}"
  nodes_subnets = module.aws-vpc.private_subnets
  main_sg_id = module.aws-sgs.main_sg_id
}