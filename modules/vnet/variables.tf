variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
}

variable "location" {
  description = "Local para implantar a rede"
  type        = string
}

variable "vnet_name" {
  description = "Nome do vnet"
  type        = string
}

variable "address_space" {
  description = "Espaço de endereço da vnet"
  type        = list(string)
}

variable "subnets" {
  description = "Configuração das sub-redes"
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
}