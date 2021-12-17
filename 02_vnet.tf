resource "azurerm_virtual_network" "bespin" {
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.bespin.location
  resource_group_name = azurerm_resource_group.bespin.name
  tags                = var.tags # (3)
}
#===================================================