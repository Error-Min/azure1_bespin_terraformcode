resource "azurerm_mysql_server" "mysqldb" {
  name                = "smterrordb"
  location            = azurerm_resource_group.bespin.location
  resource_group_name = azurerm_resource_group.bespin.name

  administrator_login          = "sangmin030"
  administrator_login_password = "!Rlflqhdl21"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"
  ssl_enforcement_enabled           = false
}

resource "azurerm_mysql_configuration" "time_zone" {
  name                = "time_zone"
  resource_group_name = azurerm_resource_group.bespin.name
  server_name         = azurerm_mysql_server.mysqldb.name
  value               = "-08:00"
}
resource "azurerm_mysql_database" "mysqldb" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.bespin.name
  server_name         = azurerm_mysql_server.mysqldb.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
resource "azurerm_mysql_firewall_rule" "mysql-db-firewall" {
  name                = "mysql-db-fire"
  resource_group_name = azurerm_resource_group.bespin.name
  server_name         = azurerm_mysql_server.mysqldb.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"  
}

resource "azurerm_private_dns_zone" "example" {
  name                = "mydomain.com"
  resource_group_name = azurerm_resource_group.bespin.name
}

resource "azurerm_private_endpoint" "DBendpoint" {
    name = "DBendpoint1"
    location = azurerm_resource_group.bespin.location
    resource_group_name = azurerm_resource_group.bespin.name
    subnet_id = azurerm_subnet.DB_Subnet.id

    private_service_connection {
        name = "smt-privateserviceconnection"
        private_connection_resource_id = azurerm_mysql_server.mysqldb.id
        is_manual_connection = false
        subresource_names = [ "mysqlServer" ]
    }

    private_dns_zone_group {
        name = "smterrordb-mysql-database-azure-com"
        private_dns_zone_ids = [ "/subscriptions/39438a80-f276-4b26-9c26-bd48ff8bc49c/resourceGroups/smt030/providers/Microsoft.Network/privateDnsZones/mydomain.com" ]
    }
}

