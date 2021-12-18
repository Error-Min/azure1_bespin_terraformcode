resource "azurerm_virtual_network" "vnet" {
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Azure1_rg.location
  resource_group_name = azurerm_resource_group.Azure1_rg.name
  tags                = var.tags # (3)
}
#===================================================