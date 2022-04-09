
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