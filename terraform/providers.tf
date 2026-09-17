terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 5.5"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-swc-001"
    storage_account_name = "wslootentfstate2026"
    container_name       = "tfstate"
    key                  = "enterprise-platform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}