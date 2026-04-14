#FUNCTION STORAGE ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_storage_access" {
  principal_id         = var.function_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = var.storage_account_id
}

#FUNCTION QUEUE ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_queue_access" {
  principal_id         = var.function_principal_id
  role_definition_name = "Storage Queue Data Contributor"
  scope                = var.storage_account_id
}

#FILE ACCESS ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_file_access" {
  principal_id         = var.function_principal_id
  role_definition_name = "Storage File Data SMB Share Contributor"
  scope                = var.storage_account_id
}

#COSMOSDB ROLE ASSIGNMENT
resource "azurerm_cosmosdb_sql_role_assignment" "function_cosmos_access" {
  resource_group_name = var.resource_group_name
  account_name        = var.cosmos_account_name

  role_definition_id = "${var.cosmos_account_id}/sqlRoleDefinitions/${local.cosmos_data_reader_role_id}"

  principal_id = var.function_principal_id

  scope = var.cosmos_account_id
}

#AZURE APP REGISTRATION (GitHub OIDC identity)
resource "azuread_application" "github" {
  display_name = "terraform-github-actions"
}

#SERVICE PRINCIPAL
resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
}

resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.github.id
  display_name          = "github-main"
  description           = "GitHub Actions OIDC for main branch"

  audiences = ["api://AzureADTokenExchange"]

  issuer  = "https://token.actions.githubusercontent.com"
  subject = "repo:DrQ-14/CloudResumeSDK:ref:refs/heads/main"
}