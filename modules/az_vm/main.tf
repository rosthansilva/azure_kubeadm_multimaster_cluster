#Create virtual machine
resource "azurerm_linux_virtual_machine" "virtualmachine" {
  name                  = var.vmname
  location              = var.location
  resource_group_name   = var.resourcegroup
  network_interface_ids = var.nic
  size                  = var.vmsize # "Standard_ D2S_v3"
  admin_username        = "toor"

  source_image_reference {
    #publisher = "Debian"
    #offer     = "debian-11"
    #sku       = "11"
    version   = "0.20220328.962"
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "toor"
    public_key = var.publickey #tls_private_key.ssh.public_key_openssh
  }

  tags = var.tags

}

#Bootstrapping essential packages
resource "azurerm_virtual_machine_extension" "customscripts" {
  name                 = var.vmname == regexall(".*kube.*", var.vmname )
  virtual_machine_id   = azurerm_linux_virtual_machine.virtualmachine.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/rosthansilva/azure_kubeadm_multimaster_cluster/main/prepara-linux.sh"],
        "commandToExecute": "sh prepara-linux.sh"
    }
SETTINGS
  tags = var.tags

}

#resource "null_resource" "ansible" {
#  provisioner "local-exec" {
#    command = <<EOT
#      cd ansible
#      sleep 300;
#      >$public_ip;
#      echo "[$public_ip]" | tee -a $public_ip;
#      echo "$public_ip ansible_user=$user ansible_ssh_private_key_file=$private_key_path" | tee -a $public_ip;
#      export ANSIBLE_HOST_KEY_CHECKING=False;
#      ansible-playbook -u $user --private-key $private_key_path -i $public_ip $provisoner
#    EOT

#    environment = {
#      public_ip        = azurerm_linux_virtual_machine.virtualmachine.public_ip_address #"${element(azurerm_linux_virtual_machine.virtualmachine.*.public_ip_address, count.index)}"
#      provisoner       = azurerm_linux_virtual_machine.virtualmachine.name == "master" ? "master-provisioner.yaml" : "slave-provisioner.yaml"
#     private_key_path = var.private_key_path
#      user             = "toor"
#    }
#  }
#  depends_on = [azurerm_virtual_machine_extension.customscripts]
#}