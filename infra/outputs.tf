output "frontend_url" {
    description = "Public URL of the frontend"
    value       = module.core.frontend_url
}

output "function_app_url" {
  description = "URL of the Azure Function backend"
  value       = module.compute.default_hostname
}

output "function_app_name" {
  description = "Function app name"
  value       = module.compute.function_app_name
}

output "storage_account_name" {
  description = "Storage account name"
  value       = module.core.storage_account_name
}

output "resource_group_name" {
    description = "Internal resource group"
    value       = module.core.resource_group_name
}

output "azure_client_id" {
  value = module.security.client_id
}

output "cosmos_endpoint" {
  description = "Cosmos DB endpoint"
  value       = module.data.endpoint
}

output "test_cosmos_db_name" {
  value = module.data.integration_test_cosmos_db_name
}

output "test_cosmos_container_name" {
  value = module.data.integration_test_cosmos_container_name
}