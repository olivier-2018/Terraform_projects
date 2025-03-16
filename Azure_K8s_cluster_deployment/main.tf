# Resource group
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
resource "azurerm_resource_group" "my_RG" {
  name     = "myRG_for_AKS"
  location = var.my_azure_location
  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

# AKS cluster
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my_aks_cluster"
  location            = azurerm_resource_group.my_RG.location
  resource_group_name = azurerm_resource_group.my_RG.name
  dns_prefix          = "dns-myaks"
  kubernetes_version  = "1.30.0"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name            = "default"
    vm_size         = "Standard_D2_v2"
    node_count      = var.node_count
    os_disk_size_gb = 30
  }

  # linux_profile {
  #   admin_username = var.username
  #   ssh_key { key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey }
  # }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    comment     = "Build from Terraform"
    environment = "Dev"
  }
}

