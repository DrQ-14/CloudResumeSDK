# RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

#STORAGE ACCOUNT (Function Requirement)
resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  shared_access_key_enabled = false

  tags = var.tags
}

#STORAGE BLOB CONTAINER
resource "azurerm_storage_container" "deploy" {
  name                  = "deploy"
  storage_account_id    = azurerm_storage_account.function_storage.id
  container_access_type = "private"
}

#STATIC WEB APP (Frontend)
resource "azurerm_static_web_app" "frontend" {
  name                = var.webapp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_tier = "Free"

  tags = var.tags
}

#CUSTOM DOMAINS
resource "azurerm_static_web_app_custom_domain" "root" {
  for_each = toset(var.custom_domains)

  static_web_app_id = azurerm_static_web_app.frontend.id
  domain_name        = each.value

  validation_type = "dns-txt-token"
}