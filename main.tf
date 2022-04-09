#Deploy dentro desse terraform 
# Cluster Kubernetes com 6 Numero de nodes (3 masters e 3 workers)
# 2 HAPROXY

resource "tls_private_key" "chavessh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "chavessh_pub" {
    content  = tls_private_key.chavessh.public_key_openssh
    filename = "./keys/id_rsa.pub"
}


resource "local_file" "chavessh_priv" {
    content  = tls_private_key.chavessh.private_key_openssh
    filename = "./keys/id_rsa"
}

resource "azurerm_resource_group" "kube" {
  name     = "kube"
  location = var.location
}

resource "azurerm_resource_group" "hub" {
  name     = "hub"
  location = var.location
}


module "hub_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = ["10.0.0.0/22"]
  subnets = [
    {
      name : "firewall-vnet"
      address_prefixes : ["10.0.0.0/24"]
    },
    {
      name : "jump-net"
      address_prefixes : ["10.0.1.0/24"]
    }
  ]
}

module "spoke_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.kube.name
  location            = var.location
  vnet_name           = var.kube_vnet_name
  address_space       = ["10.0.0.0/16"]
  subnets = [
    {
      name : "kube-subnet"
      address_prefixes : ["10.0.0.0/20"]
    },
    {
      name : "api-haproxy-lb-subnet"
      address_prefixes : ["10.0.0.0/20"]
    }
  ]
}

module "kubecluster" {
    source = "./modules/kubernetes_cluster"
    master_name = "teste" 
    master_count = 3
    worker_name = "worker-teste"
    worker_count = 1
    hpx_name = "haproxy"
    hpx_count = 2
    ssh_pub_key_file = tls_private_key.chavessh.public_key_openssh 
    subnet_id = module.hub_network.subnet_ids["kube-subnet"]
    ha_subnet_id = module.hub_network.subnet_ids["api-haproxy-lb-subnet"]
    resource_group = azurerm_resource_group.kube.name
    tags = var.default_tags
    location = var.location
    }   