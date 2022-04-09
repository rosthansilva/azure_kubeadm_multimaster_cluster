#Criação dos Masters
resource "azurerm_virtual_machine" "master" {
  count                 = var.master_count
  name                  = "${var.master_name}-${var.resource_group}-${var.location}-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = element(local.vm_nics_master, count.index + 1)
   admin_username        = var.ssh_user    
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

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
