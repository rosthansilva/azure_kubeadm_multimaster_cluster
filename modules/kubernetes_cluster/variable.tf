#Master
variable "master_name" {
  description = "Nome dos Masters"
  default     = "kube-master-"
  type        = string
}


variable "master_count" {
  description = "Numero de masters"
  default     = 3
  type        = string
}

#Worker
variable "worker_name" {
  description = "Nome dos Workers"
  default     = "kube-worker-"
  type        = string
}

variable "worker_count" {
  description = "Numero de Workers"
  default     = 3
  type        = string
}

# Ha-proxy
variable "hpx_name" {
  description = "Nome dos Workers"
  default     = "hpx-"
  type        = string
}

variable "hpx_count" {
  description = "Numero de ha-proxis"
  default     = 2
  type        = string
}

variable "ssh_user" {
  default = "htd"
}

variable "ssh_pub_key_file" {
}

variable "resource_group" {
  
}

variable "subnet_id" {
  
}

variable "ha_subnet_id" {
  
}

variable "tags" {
  
}

variable "location" {
  
}
