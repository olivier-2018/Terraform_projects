# Azure resource group
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "my_RG" {
  name     = var.resource_name
  location = var.resource_group_location

  tags     = {
    "group"     = var.resource_name,
    "Environment" = "Dev"
  }
}
