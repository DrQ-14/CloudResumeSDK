output "client_id" {
  value = azuread_application.github.client_id
}

output "github_tenant_id" {
  value = azuread_service_principal.github.application_tenant_id
}

#output "cosmos_secret_uri" {
#  value = azurerm_key_vault_secret.storage_conn_string.id
#}