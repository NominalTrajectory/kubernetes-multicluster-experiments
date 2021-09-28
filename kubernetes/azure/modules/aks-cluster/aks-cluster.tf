resource "azurerm_resource_group" "kubernetes-multicluster-experiments" {
    name = "kubernetes-multicluster-experiments"
    location = var.location
}

resource "azurerm_kubernetes_cluster" "kme-cluster-1" {
    name = "kme-cluster-1"
    location = azurerm_resource_group.kubernetes-multicluster-experiments.location
    resource_group_name = azurerm_resource_group.kubernetes-multicluster-experiments.name
    dns_prefix = "kubernetes-multicluster-experiments"

    default_node_pool {
        name = "default"
        node_count = 1
        vm_size = "Standard_E4s_v3"
        type = "VirtualMachineScaleSets"
        os_disk_size_gb = 250
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