resource "azurerm_resource_group" "orders" {
  name     = "rg-orders-dev-swc-001"
  location = "Sweden Central"

  tags = {
    Environment = var.environment
    Application = "orders"
    Project     = "enterprise-platform"
    Owner       = "william"
    ManagedBy   = "terraform"
  }
}