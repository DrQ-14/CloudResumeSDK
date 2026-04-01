terraform {
  required_version = ">= 1.5.0"

  backend "local" {} 

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.61.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Random suffix for global uniqueness
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tf_state" {
  name     = "terraform-state-rg"
  location = var.location
}

resource "azurerm_storage_account" "tf_state" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.tf_state.name
  location                 = azurerm_resource_group.tf_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tf_state" {
  name                  = "tfstate"
  storage_account_id  = azurerm_storage_account.tf_state.name
  container_access_type = "private"
}