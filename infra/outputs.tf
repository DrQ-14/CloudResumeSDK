output "frontend_url" {
    description = "Public URL of the frontend"
    value       = azurerm_static_web_app.frontend.default_host_name
}

output "function_app_url" {
  description = "URL of the Azure Function backend"
  value       = azurerm_linux_function_app.backend.default_hostname
}

output "resource_group_name" {
    description = "Internal resource group"
    value       = azurerm_resource_group.rg.name
}

output "cosmos_account_endpoint" {
  description = "Cosmos DB endpoint"
  value       = azurerm_cosmosdb_account.cosmos.endpoint
}
