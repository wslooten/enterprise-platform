output "resource_group_name" {
  description = "Name of the Orders resource group"
  value       = azurerm_resource_group.orders.name
}

output "resource_group_id" {
  description = "Azure resource ID of the Orders resource group"
  value       = azurerm_resource_group.orders.id
}

output "acr_login_server" {
  description = "Login server of the Orders Azure Container Registry"
  value       = azurerm_container_registry.orders.login_server
}