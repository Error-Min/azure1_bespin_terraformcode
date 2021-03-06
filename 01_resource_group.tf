terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.89.0"
    }
  }
}

provider "azurerm" {
  version = "=2.89.0"
  features {}
}

resource "azurerm_resource_group" "smlee_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}













resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}