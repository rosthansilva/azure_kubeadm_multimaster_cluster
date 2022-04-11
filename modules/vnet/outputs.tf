output "vnet_id" {
  description = "ID gerado da vnet"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Mapa de IDs de sub-rede gerada"
  value       = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}