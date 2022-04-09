variable "location" {
  description = "The resource group location"
  default     = "West Europe"
}

variable "kube_vnet_name" {
    default = "kube-cluser-vnet-net"
}

variable "hub_vnet_name" {
    default = "hub-vnet"
}

variable "ssh_user" {
  type = string
  default = "htd"
}

variable "ssh_key" {
}

variable "default_tags" {
  type = map
  description = "Map of Default Tags"
  default = {
    Administrator = "Rosthan Silva"
    Department = "DevOps"
    CostCentre = "HTD"
    ContactPerson = "rosthan.silva@Sinqia.com.br"
    ManagedByTerraform = "True"
  }
}