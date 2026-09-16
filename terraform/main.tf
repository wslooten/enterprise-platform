resource "azurerm_resource_group" "orders" {
  name     = "rg-${var.application}-${var.environment}-${var.region_code}-001"
  location = var.location

  tags = {
    Environment = var.environment
    Application = var.application
    Project     = "enterprise-platform"
    Owner       = "william"
    ManagedBy   = "terraform"
  }
}