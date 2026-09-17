locals {
  common_tags = {
    Environment = var.environment
    Application = var.application
    Project     = var.project
    Owner       = "william"
    ManagedBy   = "terraform"
  }
}

resource "azurerm_resource_group" "orders" {
  name     = "rg-${var.application}-${var.environment}-${var.region_code}-001"
  location = var.location

  tags = local.common_tags
}

resource "azurerm_container_registry" "orders" {
  name                = "acrordersdev001"
  resource_group_name = azurerm_resource_group.orders.name
  location            = azurerm_resource_group.orders.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = local.common_tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.orders.id
  role_definition_name = "AcrPull"
  principal_id         = "957ab5ee-360c-4f4a-9e49-31a1d02cc29b"
}