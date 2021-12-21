resource "azurerm_virtual_network" "smlee_vnet" {
  name                = "smlee-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.smlee_rg.location
  resource_group_name = azurerm_resource_group.smlee_rg.name
  tags                = var.tags # (3)
}