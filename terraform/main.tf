resource "azurerm_resource_group" "orders" {
  name     = "rg-orders-dev-swc-001"
  location = "Sweden Central"

  tags = {
    Environment = "dev"
    Application = "orders"
    Project     = "enterprise-platform"
    Owner       = "william"
    ManagedBy   = "terraform"
  }
}