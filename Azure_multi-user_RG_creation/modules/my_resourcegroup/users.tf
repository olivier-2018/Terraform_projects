# azuread_users is a data source that retrieves the object IDs of the users
# source: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users
data "azuread_users" "users" {
  user_principal_names = var.resource_contributors
}

# azurerm_role_assignment.my_roles is a resource that assigns a role to a user
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "my_roles" {
  count = length(data.azuread_users.users.object_ids)
  scope = azurerm_resource_group.my_RG.id
  principal_id = data.azuread_users.users.object_ids[count.index]
  role_definition_name = "Contributor"
}
