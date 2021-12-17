# WEB LB subnet
resource "azurerm_subnet" "WEB_LB_Subnet" {
  name                 = "web-lb-subnet"
  virtual_network_name = azurerm_virtual_network.bespin.name
  resource_group_name  = azurerm_resource_group.bespin.name
  address_prefixes     = ["10.0.1.0/29"]
}

# WEB vmss subnet
resource "azurerm_subnet" "web_vmss" {
  name                 = "web-vmss-subnet"
  virtual_network_name = azurerm_virtual_network.bespin.name
  resource_group_name  = azurerm_resource_group.bespin.name
  address_prefixes     = ["10.0.10.0/28"]
}

# WAS LB vmss subnet
resource "azurerm_subnet" "WAS_LB_Subnet" {
  name                 = "was-lb-subnet"
  virtual_network_name = azurerm_virtual_network.bespin.name
  resource_group_name  = azurerm_resource_group.bespin.name
  address_prefixes     = ["10.0.2.0/29"]
}

# WAS vmss subnet
resource "azurerm_subnet" "WAS_Vmss_Subnet" {
  name                 = "was-vmss-subnet"
  virtual_network_name = azurerm_virtual_network.bespin.name
  resource_group_name  = azurerm_resource_group.bespin.name
  address_prefixes     = ["10.0.20.0/28"]
}

# DB subnet
resource "azurerm_subnet" "DB_Subnet" {
  name                 = "db-subnet"
  virtual_network_name = azurerm_virtual_network.bespin.name
  resource_group_name  = azurerm_resource_group.bespin.name
  address_prefixes     = ["10.0.3.0/29"]
  enforce_private_link_endpoint_network_policies = true
}

# Junp BoX vmss subnet
resource "azurerm_subnet" "JumpBox_subnet" {
  name                 = "jumpbox-subnet"
  virtual_network_name = azurerm_virtual_network.bespin.name
  resource_group_name  = azurerm_resource_group.bespin.name
  address_prefixes     = ["10.0.4.0/29"]
}

resource "azurerm_subnet" "bs_sub" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.bespin.name
  virtual_network_name = azurerm_virtual_network.bespin.name
  address_prefixes = ["10.0.5.0/24"]

  }