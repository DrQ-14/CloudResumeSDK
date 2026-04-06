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

output "cosmos_account_endpoint" {
  description = "Cosmos DB endpoint"
  value       = module.data.endpoint
}

output "azure_client_id" {
  value = module.security.client_id
}

output "debug_vars" {
  value = {
    account_name_set = var.storage_account_name != ""
    key_set          = var.storage_account_access_key != ""
    key_length       = length(var.storage_account_access_key)
  }
}