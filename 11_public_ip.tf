resource "azurerm_public_ip" "smlee_appgw_pubip" {
  name                = "smlee-appgw-pubip"
  location            = azurerm_resource_group.smlee_rg.location
  resource_group_name = azurerm_resource_group.smlee_rg.name
  allocation_method   = "Static" #정적 할당
  domain_name_label   = random_string.fqdn.result
  sku                 = "Standard"
  tags                = var.tags
}
/*
resource "azurerm_public_ip" "smlee_jumpbox_pubip" {
  name                = "mlee-jumpbox-pubip"
  location            = var.location
  resource_group_name = azurerm_resource_group.smlee_rg.name
  allocation_method   = "Static"
  domain_name_label   = "${random_string.fqdn.result}-ssh"
  tags                = var.tags
}*/