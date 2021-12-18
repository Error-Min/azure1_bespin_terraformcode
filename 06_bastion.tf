resource "azurerm_public_ip" "vmss_bs_sub" {
  name                = "sm_pub"
  location            = azurerm_resource_group.Azure1_rg.location
  resource_group_name = azurerm_resource_group.Azure1_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "vmss_bsh_host" {
  name                = "sm_bsh_host"
  location            = azurerm_resource_group.Azure1_rg.location
  resource_group_name = azurerm_resource_group.Azure1_rg.name

  ip_configuration {
    name                 = "AzureBastionHost"
    subnet_id            = azurerm_subnet.bs_sub.id
    public_ip_address_id = azurerm_public_ip.vmss_bs_sub.id
  }
}
