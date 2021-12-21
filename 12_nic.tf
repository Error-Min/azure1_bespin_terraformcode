/*resource "azurerm_network_interface" "smlee_jumpbox_nic" {
  name                = "smlee-web-nic"
  location            = var.location # (2)
  resource_group_name = azurerm_resource_group.smlee_rg.name

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = azurerm_subnet.jumpbox_subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.smlee_jumpbox_pubip.id
  }
  tags = var.tags
}*/

