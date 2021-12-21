resource "azurerm_mysql_server" "smlee_mysql" {
  name                = "smlee-mysql"
  location            = azurerm_resource_group.smlee_rg.location
  resource_group_name = azurerm_resource_group.smlee_rg.name

  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"
  ssl_enforcement_enabled           = false
  public_network_access_enabled = false
}



resource "azurerm_mysql_configuration" "time_zone" {
  name                = "time_zone"
  resource_group_name = azurerm_resource_group.smlee_rg.name
  server_name         = azurerm_mysql_server.smlee_mysql.name
  value               = "-09:00"
}
resource "azurerm_mysql_database" "petclinic" {
  name                = "petclinic"
  resource_group_name = azurerm_resource_group.smlee_rg.name
  server_name         = azurerm_mysql_server.smlee_mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}


/*resource "azurerm_mysql_firewall_rule" "mysqlfw" {
  name                = "smlee_mysqlfw"
  resource_group_name = azurerm_resource_group.smlee_rg.name
  server_name         = azurerm_mysql_server.smlee_mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}*/

resource "azurerm_private_dns_zone" "smlee_private_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.smlee_rg.name
}

resource "azurerm_private_endpoint" "smlee_private_endpoint" {
    name = "DBendpoint1"
    location = azurerm_resource_group.smlee_rg.location
    resource_group_name = azurerm_resource_group.smlee_rg.name
    subnet_id = azurerm_subnet.smlee_db_subnet.id

    private_service_connection {
        name = "smt-privateserviceconnection"
        private_connection_resource_id = azurerm_mysql_server.smlee_mysql.id
        is_manual_connection = false
        subresource_names = [ "mysqlServer" ]
    }

    private_dns_zone_group {
        name = "smlee-mysql-mysql-database-azure-com"
        private_dns_zone_ids = [ azurerm_private_dns_zone.smlee_private_dns_zone.id ]
}
}
resource "azurerm_private_dns_zone_virtual_network_link" "smlee_dns_link" {
  name                  = "smlee-dns-link"
  resource_group_name   = azurerm_resource_group.smlee_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.smlee_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.smlee_vnet.id
}