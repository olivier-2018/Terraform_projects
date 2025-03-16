# Azure Provider source and version to use
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23.0"
    }
  }
}
# Configure the Azure provider
# source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  subscription_id = var.azure_subscriptionid
  features {    
    resource_group {      
      prevent_deletion_if_contains_resources = false
    }
  }
}

