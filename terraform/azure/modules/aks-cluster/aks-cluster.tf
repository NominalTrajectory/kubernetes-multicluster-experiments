locals {
    network_cidr = "192.168.0.0/16"
    nodes_cidr = "192.168.1.0/24"
    pod_cidr = "10.0.0.0/16"
    service_cidr = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
    docker_bridge_cidr = "172.18.0.1/16"
}

resource "azurerm_virtual_network" "kme-cluster1-vnet" {
  name                = "kme-cluster1-vnet"
  location            = var.azure_location
  resource_group_name = var.rg_name
  address_space       = [local.network_cidr]
}

resource "azurerm_subnet" "kme-cluster1-subnet" {
  name                 = "kme-cluster1-subnet"
  virtual_network_name = azurerm_virtual_network.kme-cluster1-vnet.name
  resource_group_name  = var.rg_name
  address_prefixes     = [local.nodes_cidr]
}

resource "azurerm_kubernetes_cluster" "kme-cluster-1" {
    name = "kme-cluster-1"
    location = var.azure_location
    resource_group_name = var.rg_name
    dns_prefix = "kubernetes-multicluster-experiments"

    default_node_pool {
        name = "default"
        node_count = 2
        vm_size = "Standard_D2_v2"
        type = "VirtualMachineScaleSets"
        os_disk_size_gb = 50
    }

    identity {
      type = "SystemAssigned"
    }

    linux_profile {
        admin_username = "azureuser"
        ssh_key {
            key_data = var.ssh_key
        }
    }

    network_profile {
        network_plugin = "kubenet"
        load_balancer_sku = "Standard"
        dns_service_ip = local.dns_service_ip
        docker_bridge_cidr = local.docker_bridge_cidr
        pod_cidr = local.pod_cidr
        service_cidr = local.service_cidr
    }

    addon_profile {
      aci_connector_linux {
          enabled = false
      }

      azure_policy {
          enabled = false
      }

      http_application_routing {
          enabled = false
      }

      kube_dashboard {
          enabled = false
      }

      oms_agent {
          enabled = false
      }
    }
}