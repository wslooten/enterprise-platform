locals {
  common_tags = {
    Environment = var.environment
    Application = var.application
    Project     = var.project
    Owner       = "william"
    ManagedBy   = "terraform"
  }
}

data "azurerm_client_config" "current" {}

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

resource "azurerm_key_vault" "orders" {
  name                = "kv-orders-dev-swc-001"
  location            = azurerm_resource_group.orders.location
  resource_group_name = azurerm_resource_group.orders.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true

  tags = local.common_tags
}

resource "azurerm_user_assigned_identity" "orders_api" {
  name                = "id-orders-api-dev-swc-001"
  resource_group_name = azurerm_resource_group.orders.name
  location            = azurerm_resource_group.orders.location

  tags = local.common_tags
}
resource "azurerm_role_assignment" "orders_api_keyvault_secrets_user" {
  scope                = azurerm_key_vault.orders.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.orders_api.principal_id
}

resource "azurerm_federated_identity_credential" "orders_api" {
  name                      = "fic-orders-api"
  user_assigned_identity_id = azurerm_user_assigned_identity.orders_api.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer  = "https://swedencentral.oic.prod-aks.azure.com/d9b5111a-9ba2-417d-bede-5edee1c90dcf/b70796e1-fb8f-43ee-9d3e-8c093b1984e5/"
  subject = "system:serviceaccount:default:orders-api-sa"
}

resource "azurerm_log_analytics_workspace" "orders" {
  name                = "log-orders-dev-swc-001"
  location            = azurerm_resource_group.orders.location
  resource_group_name = azurerm_resource_group.orders.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = local.common_tags
}

resource "azurerm_monitor_workspace" "orders" {
  name                = "amw-orders-dev-swc-001"
  resource_group_name = azurerm_resource_group.orders.name
  location            = azurerm_resource_group.orders.location

  tags = local.common_tags
}

resource "azurerm_monitor_alert_prometheus_rule_group" "orders" {
  name                = "prom-orders-api-alerts"
  location            = azurerm_resource_group.orders.location
  resource_group_name = azurerm_resource_group.orders.name

  scopes = [
    azurerm_monitor_workspace.orders.id
  ]

  cluster_name       = "aks-bootcamp"
  interval           = "PT1M"
  rule_group_enabled = true

  rule {
    alert   = "OrdersApiReplicasUnavailable"
    enabled = true

    expression = <<-PROMQL
  kube_deployment_status_replicas_available{deployment="orders-api"}
  <
  kube_deployment_spec_replicas{deployment="orders-api"}
PROMQL

    for      = "PT2M"
    severity = 2

    annotations = {
      summary     = "Orders API has unavailable replicas"
      description = "The number of available Orders API replicas is lower than the desired number of replicas."
    }
  }

  tags = local.common_tags
}



