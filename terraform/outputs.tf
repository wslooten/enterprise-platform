output "resource_group_name" {
  description = "Name of the Orders resource group"
  value       = azurerm_resource_group.orders.name
}

output "resource_group_id" {
  description = "Azure resource ID of the Orders resource group"
  value       = azurerm_resource_group.orders.id
}