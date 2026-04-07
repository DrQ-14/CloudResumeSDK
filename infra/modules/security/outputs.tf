output "client_id" {
  value = azuread_application.github.client_id
}

output "github_tenant_id" {
  value = azuread_service_principal.github.application_tenant_id
}

output "storage_secret_uri" {
  value = azurerm_key_vault_secret.storage_conn_string.id
}

output "storage_connection_string" {
  value     = local.storage_connection_string
  sensitive = true
}

output "debug_connection_string" {
  value = replace(
    local.storage_connection_string,
    var.storage_account_access_key,
    "REDACTED"
  )
}