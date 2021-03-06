resource "azurerm_application_gateway" "smlee_web_appgw" {
  name                = "smlee-web-appgw"
  resource_group_name = azurerm_resource_group.smlee_rg.name
  location            = azurerm_resource_group.smlee_rg.location
  #zones = ["1", "2", "3"] 웹에는 22랑 443 점프는 22만 와스는 8009만

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "appgw-conf"
    subnet_id = azurerm_subnet.smlee_appgw_subnet.id
  }

  frontend_port {
    name = "frontend-80"
    port = 80
  }
  frontend_port {
    name = "frontend-443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.smlee_appgw_pubip.id
  }

  frontend_ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.smlee_appgw_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
  }

  backend_address_pool {
    name = "backend"
  }

  backend_http_settings {
    name                                = "settings-80"
    pick_host_name_from_backend_address = true
    #probe_name                          = "probe-443"
    cookie_based_affinity               = "Disabled"
    port                                = 80
    path                                = "/"
    protocol                            = "Http"
    request_timeout                     = 20
  }


  backend_http_settings {
    name                                = "settings-443"
    pick_host_name_from_backend_address = true
    probe_name                          = "probe-443"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    path                                = "/"
    protocol                            = "Https"
    request_timeout                     = 20
  }

  http_listener {
    name                           = "listener-80"
    frontend_ip_configuration_name = "public-ip"
    frontend_port_name             = "frontend-80"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "listener-443"
    frontend_ip_configuration_name = "public-ip"
    frontend_port_name             = "frontend-443"
    protocol                       = "Https"
    ssl_certificate_name           = "cert"
  }

  ssl_certificate {
    name     = "cert"
    data     = filebase64("certificate.pfx")
    password = "1234"
  }

  probe {
    name                                      = "probe-443"
    path                                      = "/"
    protocol                                  = "Https"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    //host = "contoso.com"

    match {}
  }

  redirect_configuration {
    name                 = "redirect"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "listener-443"
  }

  request_routing_rule {
    name                       = "rule-443"
    rule_type                  = "Basic"
    http_listener_name         = "listener-443"
    backend_address_pool_name  = "backend"
    backend_http_settings_name = "settings-80"
  }

  request_routing_rule {
    name                        = "rule-80"
    rule_type                   = "Basic"
    http_listener_name          = "listener-80"
    redirect_configuration_name = "redirect"
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "smlee_web_vmss" {
  name                            = "smlee-web-vmss"
  location                        = azurerm_resource_group.smlee_rg.location # (2)
  resource_group_name             = azurerm_resource_group.smlee_rg.name
  sku                             = "Standard_DS1_v2" # 머신 디스크 크기 선택 및 vmss 개수 지정 
  instances                       = 2                 # vmss 가상머신 개수.
  admin_username                  = "korean"
  admin_password                  = "@korean931912"
  disable_password_authentication = false
  custom_data                     = base64encode("websh.sh")


  source_image_reference {
    # VM OS 설정및 변경
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"

  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  data_disk {
    lun     = 0
    caching = "ReadWrite"
    #create_option = "Empty"
    disk_size_gb         = 10
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = azurerm_subnet.smlee_web_subnet.id
      primary                                = true
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.smlee_web_appgw.backend_address_pool[0].id]
    }
  }


  extension {
    name                       = "CustomScript"
    publisher                  = "Microsoft.Azure.Extensions"
    type                       = "CustomScript"
    type_handler_version       = "2.0"
    auto_upgrade_minor_version = true

    settings = <<SETTINGS
  {
      "script": "${filebase64("websh.sh")}"
  }
  SETTINGS
  }
}
resource "azurerm_monitor_autoscale_setting" "smlee_web_auto" {
  name                = "smlee-web-auto"
  resource_group_name = azurerm_resource_group.smlee_rg.name
  location            = azurerm_resource_group.smlee_rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.smlee_web_vmss.id

  profile {
    name = "smlee-web-AutoScale"

    capacity {
      default = 2
      minimum = 1
      maximum = 7
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.smlee_web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 65
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.smlee_web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}