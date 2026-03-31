output "frontend_url" {
    description = "Public URL of the frontend"
    value       = azurerm_static_web_app.frontend.default_host_name
}

output "function_app_url" {
  description = "URL of the Azure Function backend"
  value       = azurerm_linux_function_app.backend.default_hostname
}

output "function_app_name" {
  description = "Function app name"
  value       = azurerm_linux_function_app.backend.name
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.function_storage.name
}

output "resource_group_name" {
    description = "Internal resource group"
    value       = azurerm_resource_group.rg.name
}

output "cosmos_account_endpoint" {
  description = "Cosmos DB endpoint"
  value       = module.cosmos.endpoint
}

output "azure_client_id" {
  value = azuread_application.github.client_id
}