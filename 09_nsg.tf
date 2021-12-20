#jumpboxnsg
resource "azurerm_network_security_group" "jumpbox-nsg" {
  name                = "hbkim-nsg"
  location            = azurerm_resource_group.Azure1_rg.location
  resource_group_name = azurerm_resource_group.Azure1_rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_subnet_network_security_group_association" "jump-box" {
 subnet_id                 =azurerm_subnet.JumpBox_subnet.id
  network_security_group_id = azurerm_network_security_group.jumpbox-nsg.id
}


#wasnsg
resource "azurerm_network_security_group" "was-nsg" {
  name                = "was-nsg"
  location            = azurerm_resource_group.Azure1_rg.location
  resource_group_name = azurerm_resource_group.Azure1_rg.name
  
  
  security_rule {
    name                       = "was-rule"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["8080" , "8009"]
    
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
 

}
resource "azurerm_subnet_network_security_group_association" "was-ass" {
 subnet_id                 = azurerm_subnet.WAS_Vmss_Subnet.id
  network_security_group_id = azurerm_network_security_group.was-nsg.id
}
#webnsg
resource "azurerm_subnet_network_security_group_association" "web-ass" {
 subnet_id                 = azurerm_subnet.web_vmss.id
  network_security_group_id = azurerm_network_security_group.web-nsg.id
}




resource "azurerm_network_security_group" "web-nsg" {
  name                = "web-nsg"
  location            = azurerm_resource_group.Azure1_rg.location
  resource_group_name = azurerm_resource_group.Azure1_rg.name
  
  
  security_rule {
    name                       = "web-rule"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80"]
    
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
 

}



  