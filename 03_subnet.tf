# WEB LB subnet
resource "azurerm_subnet" "smlee_appgw_subnet" {
  name                 = "smlee-appgw-subnet"
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  resource_group_name  = azurerm_resource_group.smlee_rg.name
  address_prefixes     = ["10.0.1.0/28"]
}

# WEB vmss subnet
resource "azurerm_subnet" "smlee_web_subnet" {
  name                 = "smlee-web-subnet"
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  resource_group_name  = azurerm_resource_group.smlee_rg.name
  address_prefixes     = ["10.0.10.0/28"]
}

# WAS LB vmss subnet
resource "azurerm_subnet" "smlee_lb_subnet" {
  name                 = "smlee-lb-subnet"
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  resource_group_name  = azurerm_resource_group.smlee_rg.name
  address_prefixes     = ["10.0.2.0/29"]
}

# WAS vmss subnet
resource "azurerm_subnet" "smlee_was_subnet" {
  name                 = "smlee-was-subnet"
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  resource_group_name  = azurerm_resource_group.smlee_rg.name
  address_prefixes     = ["10.0.20.0/28"]
}

# DB subnet
resource "azurerm_subnet" "smlee_db_subnet" {
  name                 = "db-subnet"
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  resource_group_name  = azurerm_resource_group.smlee_rg.name
  enforce_private_link_endpoint_network_policies = true
  address_prefixes     = ["10.0.3.0/29"]
  /*service_endpoints    = ["Microsoft.Storage"] # 여기 추가 해줘야 유연한거 올라감 ㄹㅇㅋㅋ
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }# 단일 서버로 가면 지워야됨*/
}

# Junp BoX vmss subnet
resource "azurerm_subnet" "jumpbox_subnet" {
  name                 = "jumpbox-subnet"
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  resource_group_name  = azurerm_resource_group.smlee_rg.name
  address_prefixes     = ["10.0.4.0/29"]
}

resource "azurerm_subnet" "bs_subnet" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.smlee_rg.name
  virtual_network_name = azurerm_virtual_network.smlee_vnet.name
  address_prefixes = ["10.0.5.0/24"]
  }