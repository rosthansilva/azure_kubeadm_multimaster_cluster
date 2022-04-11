terraform {
  required_version = "~>1.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

}

provider "azurerm" {
  features {}
}



#Deploy dentro desse terraform 
# Cluster Kubernetes com 6 Numero de nodes (3 masters e 3 workers)
# 2 HAPROXY

resource "azurerm_resource_group" "kube" {
  name     = "kube"
  location = var.location
}

resource "azurerm_resource_group" "hub" {
  name     = "hub"
  location = var.location
}

#############

module "hub_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = ["10.0.0.0/22"]
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : ["10.0.0.0/24"]
    },
    {
      name : "bastion-subnet"
      address_prefixes : ["10.0.1.0/24"]
    },
    {
      name : "jenkins-subnet"
      address_prefixes : ["10.0.2.0/24"]
    }
  ]
}

module "kube_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.kube.name
  location            = var.location
  vnet_name           = var.kube_vnet_name
  address_space       = ["10.15.0.0/16"]
  subnets = [
    {
      name : "kube-subnet"
      address_prefixes : ["10.15.0.0/20"]
    },
    {
      name : "api-haproxy-lb-subnet"
      address_prefixes : ["10.15.16.0/20"]
    }
  ]
}

module "vnet_peering" {
  source              = "./modules/vnet_peering"
  vnet_1_name         = var.hub_vnet_name
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = azurerm_resource_group.hub.name
  vnet_2_name         = var.kube_vnet_name
  vnet_2_id           = module.kube_network.vnet_id
  vnet_2_rg           = azurerm_resource_group.kube.name
  peering_name_1_to_2 = "HubToSpoke1"
  peering_name_2_to_1 = "Spoke1ToHub"
}

#############



#Criar cartão de interface de rede 
resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vmname)
  name                = join("-nic", [each.value])
  location            = azurerm_resource_group.kube.location
  resource_group_name = azurerm_resource_group.kube.name

  ip_configuration {
    name                          = "kubeconfig"
    subnet_id                     = module.kube_network.subnet_ids["kube-subnet"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[each.key].id #azurerm_public_ip.publicip.id
  }
  depends_on       = [module.kube_network.subnet]
}

resource "azurerm_public_ip" "publicip" {
  for_each = toset(var.vmname)
  name     = join("-nic", [each.value])
  location            = azurerm_resource_group.kube.location
  resource_group_name = azurerm_resource_group.kube.name
  allocation_method   = "Static"
  domain_name_label   = join("-node", [each.value])
  tags = var.default_tags
}

module "vm_module" {
  source           = "./modules/az_vm"
  for_each         = toset(var.vmname)
  vmname           = each.value
  resourcegroup    = azurerm_resource_group.kube.name
  location         = azurerm_resource_group.kube.location
  nic              = [azurerm_network_interface.nic[each.key].id]
  publickey        = file("~/.ssh/id_rsa.pub")
  vmsize           = each.value == "kube-master-${each.key}" ? "Standard_D2s_v3" : "Standard_B2s" # "Standard_D2S_v3"
  public_ip        = [azurerm_public_ip.publicip[each.key].fqdn]
  private_key_path = "~/.ssh/id_rsa"
  depends_on       = [azurerm_network_interface.nic]
  tags = var.default_tags
  script_url = each.value == "kube-master-${each.key}" ? "${local.scripts.kube}" : "${local.scripts.haproxy}" #
  script_name =  "script.sh"
}