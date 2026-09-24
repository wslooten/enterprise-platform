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

  rbac_authorization_enabled    = true
  public_network_access_enabled = false

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

resource "azurerm_virtual_network" "orders" {
  name                = "vnet-${var.application}-${var.environment}-${var.region_code}-001"
  location            = azurerm_resource_group.orders.location
  resource_group_name = azurerm_resource_group.orders.name

  address_space = ["10.50.0.0/16"]

  tags = local.common_tags
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks-${var.environment}-${var.region_code}-001"
  resource_group_name  = azurerm_resource_group.orders.name
  virtual_network_name = azurerm_virtual_network.orders.name

  address_prefixes = ["10.50.0.0/20"]
}

resource "azurerm_subnet" "apim" {
  name                 = "snet-apim-${var.environment}-${var.region_code}-001"
  resource_group_name  = azurerm_resource_group.orders.name
  virtual_network_name = azurerm_virtual_network.orders.name

  address_prefixes = ["10.50.16.0/24"]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-pe-${var.environment}-${var.region_code}-001"
  resource_group_name  = azurerm_resource_group.orders.name
  virtual_network_name = azurerm_virtual_network.orders.name

  address_prefixes = ["10.50.17.0/24"]
}

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks-${var.environment}-${var.region_code}-001"
  location            = azurerm_resource_group.orders.location
  resource_group_name = azurerm_resource_group.orders.name

  security_rule {
    name                       = "Allow-APIM-to-AKS-HTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "10.50.16.0/24"
    destination_address_prefix = "10.50.0.0/20"
  }

  security_rule {
    name                       = "Deny-VNet-to-AKS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.50.0.0/20"
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-kv-${var.application}-${var.environment}-${var.region_code}-001"
  location            = azurerm_resource_group.orders.location
  resource_group_name = azurerm_resource_group.orders.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-kv-${var.application}-${var.environment}-${var.region_code}-001"
    private_connection_resource_id = azurerm_key_vault.orders.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  tags = local.common_tags
}
resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.orders.name

  tags = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                = "link-kv-${var.environment}-${var.region_code}-001"
  private_dns_zone_id = azurerm_private_dns_zone.key_vault.id
  virtual_network_id  = azurerm_virtual_network.orders.id

  registration_enabled = false

  tags = local.common_tags
}

data "azurerm_virtual_network" "aks_existing" {
  name                = "aks-vnet-31331356"
  resource_group_name = "MC_rg-aks-sweden_aks-bootcamp_swedencentral"
}

resource "azurerm_virtual_network_peering" "platform_to_aks" {
  name                      = "peer-platform-to-aks"
  resource_group_name       = azurerm_resource_group.orders.name
  virtual_network_name      = azurerm_virtual_network.orders.name
  remote_virtual_network_id = data.azurerm_virtual_network.aks_existing.id

  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "aks_to_platform" {
  name                      = "peer-aks-to-platform"
  resource_group_name       = data.azurerm_virtual_network.aks_existing.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.aks_existing.name
  remote_virtual_network_id = azurerm_virtual_network.orders.id

  allow_virtual_network_access = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_aks" {
  name                = "link-kv-aks-${var.environment}-${var.region_code}-001"
  private_dns_zone_id = azurerm_private_dns_zone.key_vault.id
  virtual_network_id  = data.azurerm_virtual_network.aks_existing.id

  registration_enabled = false

  tags = local.common_tags
}








