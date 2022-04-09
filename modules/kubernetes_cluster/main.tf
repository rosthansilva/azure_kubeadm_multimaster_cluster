##Criação das Depndencias

resource "azurerm_network_interface" "master" {
  count                 = var.master_count
  name                = "master-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "master-testconfiguration-${count.index + 1}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "worker" {
  count                 = var.worker_count
  name                = "worker-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "worker-testconfiguration-${count.index + 1}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "hpx" {
  count               = var.hpx_count
  name                = "master-nic-${count.index + 1}"
  location            = var.location
  resource_group_name      = var.resource_group

  ip_configuration {
    name                          = "hpx-testconfiguration-${count.index + 1}"
    subnet_id                     = var.ha_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

locals {
  vm_nics_master = chunklist(azurerm_network_interface.master[*].id, 1)
  vm_nics_worker = chunklist(azurerm_network_interface.worker[*].id, 1)
  vm_nics_hpx = chunklist(azurerm_network_interface.hpx[*].id, 1)
  }

locals {
 vm_name_master = "${var.master_name}-${var.resource_group}-${var.location}"
 vm_name_worker = "${var.worker_name}-${var.resource_group}-${var.location}"
 vm_name_hpx = "${var.hpx_name}-${var.resource_group}-${var.location}"
} 
