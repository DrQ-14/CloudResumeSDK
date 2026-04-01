

#FUNCTION MODULE
module "function" {
  source = "./modules/function"

  name                = local.function_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  function_plan_name = local.function_plan_name

  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

  cosmos_endpoint       = module.cosmos.endpoint
  cosmos_database_name  = module.cosmos.database_name
  cosmos_container_name = module.cosmos.container_name

  cors_origins = var.cors_origins

}

#COSMOSDB MODULE
module "cosmos" {
  source = "./modules/cosmos"

  name                = local.cosmos_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  database_name  = local.cosmos_database_name
  container_name = local.cosmos_container_name
}

#FUNCTION STORAGE ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_storage_access" {
  principal_id         = module.function.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

#FUNCTION QUEUE ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_queue_access" {
  principal_id         = module.function.principal_id
  role_definition_name = "Storage Queue Data Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

#COSMOSDB ROLE ASSIGNMENT
resource "azurerm_cosmosdb_sql_role_assignment" "function_cosmos_access" {
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = module.cosmos.name

  role_definition_id = "${module.cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"

  principal_id = module.function.principal_id

  scope = module.cosmos.id
}

#FILE ACCESS ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_file_access" {
  principal_id         = module.function.principal_id
  role_definition_name = "Storage File Data SMB Share Contributor"
  scope                = azurerm_storage_account.function_storage.id
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