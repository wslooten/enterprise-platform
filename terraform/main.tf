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