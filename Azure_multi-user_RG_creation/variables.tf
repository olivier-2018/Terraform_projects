# Environment variables
variable "azure_subscriptionid" {}
variable "host_ip" {}
variable "my_azure_location" {}

# Resouce Group Configuration
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
variable "resourcegroup_cfg" {
  type = list(object({ 
    name = string
    user = list(string)
    })
  )
}


