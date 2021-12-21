resource "azurerm_virtual_machine" "smlee_jumpbox" {
  name                  = "smlee-jumpbox"
  location              = var.location # (2)
  resource_group_name   = azurerm_resource_group.smlee_rg.name
  network_interface_ids = [azurerm_network_interface.smlee_jumpbox_nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = var.admin_user     # (5)
    admin_password = var.admin_password # (6)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.vmtags # (3)
}