resource "azurerm_resource_group" "kubernetes-multicluster-experiments" {
    name = "kubernetes-multicluster-experiments"
    location = var.azure_location
}