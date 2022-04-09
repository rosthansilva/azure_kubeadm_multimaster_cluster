
#Criação dos Workers
resource "azurerm_virtual_machine" "workers" {
  count                 = var.worker_count
  name                  = "${var.worker_name}-${var.resource_group}-${var.location}-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group    
  size                  = "Standard_DS1_v2"
  admin_username        = var.ssh_user
  network_interface_ids = element(local.vm_nics_worker, count.index + 1)

  admin_ssh_key {
    username = var.ssh_user
    public_key = file("~/.ssh/id_rsa.pub")
  }
  
  storage_image_reference {
    publisher = "credativ"
    offer     = "Debian"
    sku       = "Diabian-11"
    version   = "latest"
  }

   os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  } 

  tags = var.tags
}

