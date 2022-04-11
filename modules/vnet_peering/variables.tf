variable "vnet_1_name" {
  description = "Vnet 1 nome"
  type        = string
}

variable "vnet_1_id" {
  description ="VNET 1 ID"
  type        = string
}

variable "vnet_1_rg" {
  description ="Grupo de recursos do VNET 1"
  type        = string
}

variable "vnet_2_name" {
  description ="Nome do vnet 2"
  type        = string
}

variable "vnet_2_id" {
  description = "vnet2Id"
  type        = string
}

variable "vnet_2_rg" {
  description = "Grupo de recursos do VNET 2"
  type        = string
}

variable "peering_name_1_to_2" {
  description = "(opcional) olhando 1 a 2 nome"
  type        = string
  default     = "peering1to2"
}

variable "peering_name_2_to_1" {
  description = "(opcional) olhando 2 a 1 nome"
  type        = string
  default     = "peering2to1"
}