#jumpboxnsg
/*resource "azurerm_network_security_group" "smlee_jumpbox_nsg" {
  name                = "smlee-jumpbox-nsg"
  location            = azurerm_resource_group.smlee_rg.location
  resource_group_name = azurerm_resource_group.smlee_rg.name

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
    source_address_prefix      = "*" #내 ip iptime
    destination_address_prefix = "*" #내 ip iptime
  }
}
resource "azurerm_subnet_network_security_group_association" "smlee_jumpbox_ass" {
 subnet_id                 =azurerm_subnet.jumpbox_subnet.id
  network_security_group_id = azurerm_network_security_group.smlee_jumpbox_nsg.id
}*/

#===================================================================================

resource "azurerm_network_security_group" "smlee_was_nsg" {
  name                = "was-nsg"
  location            = azurerm_resource_group.smlee_rg.location
  resource_group_name = azurerm_resource_group.smlee_rg.name
  security_rule {
    name                       = "was-ssh"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" #내 ip iptime
    destination_address_prefix = "*" #내 ip iptime
  }
  
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

  security_rule {
    name                       = "HTTP"
    priority                   = 104
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
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "tomcat"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "petclinic"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8009"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 
}
resource "azurerm_subnet_network_security_group_association" "smlee_was-ass" {
 subnet_id                 = azurerm_subnet.smlee_was_subnet.id
  network_security_group_id = azurerm_network_security_group.smlee_was_nsg.id 
}

#======================================================================================

#webnsg
resource "azurerm_network_security_group" "smlee_web_nsg" {
  name                = "smlee-web-nsg"
  location            = azurerm_resource_group.smlee_rg.location
  resource_group_name = azurerm_resource_group.smlee_rg.name
  
  security_rule {
    name                       = "web-http-rule"
    priority                   = 108
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web-https-rule"
    priority                   = 109
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "smlee_web_ass" {
 subnet_id                 = azurerm_subnet.smlee_web_subnet.id
  network_security_group_id = azurerm_network_security_group.smlee_web_nsg.id
}