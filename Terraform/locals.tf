# Variables générales:
locals {
  subscription_id     = "c56aea2c-50de-4adc-9673-6a8008892c21"
  resource_group_name = "b3-gr5"
  location            = data.azurerm_resource_group.main.location
}

# Network variables (only 2 networks)
locals {
  network_europe = ["10.1.0.0/16"]
  subnets_europe = ["10.1.1.0/24"]
}

# Variables pour la machine virtuelle
locals {
  public_ip_allocation_method = "Static"
  vm_domain_name_label        = "${lower(replace(local.resource_group_name, "_", ""))}-vm"
  public_ip_sku               = "Standard"

  vm_size = "Standard_B1s"

  os_disk_caching           = "ReadWrite"
  os_disk_create_option     = "FromImage"
  os_disk_managed_disk_type = "Standard_LRS"

  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  ip_simplon = "82.126.234.200"

  admin_username = "adminuser"
  path           = "/home/${local.admin_username}/.ssh/authorized_keys"
  ssh_key        = tls_private_key.admin_rsa.public_key_openssh

  ssh_ip_filter = concat([for user_value in local.users : user_value.ip], [local.ip_simplon])
}

# Add users 
locals {
  users = {
    johann = {
      sshkey      = "johann"
      private_key = "johann"
      ip          = "62.34.36.24"
    }
    sebastien = {
      sshkey      = "sebastien"
      private_key = "sebastien"
      ip          = "83.195.211.184"
    }
  }
}