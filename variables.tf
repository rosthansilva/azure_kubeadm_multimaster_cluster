variable "location" {
  description = "The resource group location"
  default     = "West Europe"
}

variable "kube_vnet_name" {
  default = "kube-vnet"
}

variable "hub_vnet_name" {
  default = "hub-vnet"
}

variable "vmname" {
  description = "Nome da VM"
  type        = list(any)
  default     = ["kube-master-1", 
                 "kube-master-2", 
                 "kube-master-3",
                 "kube-worker-1", 
                 "kube-worker-2",
                 "kube-worker-3",
                 "ha-proxy-1"
                 ]
}

variable "default_tags" {
  type        = map(any)
  description = "Map of Default Tags"
  default = {
    Administrator      = "Rosthan Silva"
    Department         = "DevOps"
    CostCentre         = "HTD"
    ContactPerson      = "rosthan.silva@Sinqia.com.br"
    ManagedByTerraform = "True"
  }
}