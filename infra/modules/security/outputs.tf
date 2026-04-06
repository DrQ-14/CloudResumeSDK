output "client_id" {
  value = azuread_application.github.client_id
}

output "github_tenant_id" {
  value = azuread_service_principal.github.application_tenant_id
}

output "storage_secret_uri" {
  value = azurerm_key_vault_secret.storage_conn_string.id
}

output "debug_module_vars" {
  value = {
    account_name_set = var.storage_account_name != ""
    key_set          = var.storage_account_access_key != ""
  }
}