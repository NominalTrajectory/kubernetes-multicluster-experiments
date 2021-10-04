locals {
    network_cidr = "192.168.0.0/16" # to be used for a vpc
    nodes_cidr = "192.168.1.0/24" # subnet in which Kubernetes nodes will be launched
    pod_cidr = "10.4.0.0/16" # secondary range for Kubernetes pods
    service_cidr = "10.5.0.0/16" # secondary range for Kubernetes services
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"
  
  name = "kme-cluster3-vpc"
  cidr = local.network_cidr

  private_subnets = [local.nodes_cidr]
  public_subnets  = []

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}