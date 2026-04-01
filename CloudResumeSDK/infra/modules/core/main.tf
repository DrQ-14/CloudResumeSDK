# RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

#STATIC WEB APP (Frontend)
resource "azurerm_static_web_app" "frontend" {
  name                = local.webapp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_tier = "Free"
}

#CUSTOM DOMAINS
resource "azurerm_static_web_app_custom_domain" "root" {
  for_each = toset(var.custom_domains)

  static_web_app_id = azurerm_static_web_app.frontend.id
  domain_name        = each.value

  validation_type = "dns-txt-token"
}

resource "azurerm_static_web_app_custom_domain" "www" {
  static_web_app_id = azurerm_static_web_app.frontend.id
  domain_name       = "www.tanager-solutions.com"
  validation_type   = "cname-delegation"
}