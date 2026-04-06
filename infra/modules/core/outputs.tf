output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = var.location
}

output "storage_account_name" {
  value = azurerm_storage_account.function_storage.name
}

output "storage_account_id" {
  value = azurerm_storage_account.function_storage.id
}

output "storage_account_access_key" {
  value = azurerm_storage_account.function_storage.primary_access_key
  sensitive = true
}

output "static_web_app_id" {
  value = azurerm_static_web_app.frontend.id
}

output "frontend_url" {
  value = azurerm_static_web_app.frontend.default_host_name
}

output "debug_storage_values" {
  value = {
    key = azurerm_storage_account.function_storage.primary_access_key
  }
}