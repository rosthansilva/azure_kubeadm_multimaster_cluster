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
  description = "Nome das VMs - Kubernetes"
  type        = list(any)
  default     = ["kube-master-1", 
                 "kube-master-2", 
                 "kube-master-3",
                 "kube-worker-1", 
                 "kube-worker-2",
                 "kube-worker-3",
                 "ha-proxy-1",
                 "ha-proxy-2"
                 ]
}

locals {
  scripts = {
  kube = "https://raw.githubusercontent.com/rosthansilva/azure_kubeadm_multimaster_cluster/main/scripts/kube/script.sh"
  haproxy = "https://raw.githubusercontent.com/rosthansilva/azure_kubeadm_multimaster_cluster/main/scripts/haproxy/script.sh"  
  }
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