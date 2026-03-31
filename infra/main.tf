# RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

#STATIC WEB APP (Frontend)
resource "azurerm_static_web_app" "frontend" {
  name                = local.webapp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_tier = "Free"
}

#CUSTOM DOMAINS
resource "azurerm_static_web_app_custom_domain" "root" {
  for_each = toset(var.custom_domains)

  static_web_app_id = azurerm_static_web_app.frontend.id
  domain_name        = each.value

  validation_type = "dns-txt-token"
}

resource "azurerm_static_web_app_custom_domain" "www" {
  static_web_app_id = azurerm_static_web_app.frontend.id
  domain_name       = "www.tanager-solutions.com"
  validation_type   = "cname-delegation"
}

#STORAGE ACCOUNT (Function Requirement)
resource "azurerm_storage_account" "function_storage" {
  name                     = local.storage_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  shared_access_key_enabled = true
}

#FUNCTION APP CONSUMPTION PLAN
resource "azurerm_service_plan" "serverless_plan" {
  name                = local.function_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"
  sku_name            = "Y1"  # Consumption plan
}


#FUNCTION APP
resource "azurerm_linux_function_app" "backend" {
   name                       = local.function_name
   location                   = azurerm_resource_group.rg.location
   resource_group_name        = azurerm_resource_group.rg.name

   service_plan_id            = azurerm_service_plan.serverless_plan.id

   storage_account_name       = azurerm_storage_account.function_storage.name

  identity {
    type = "SystemAssigned"
  }

   site_config {
    application_stack {
      dotnet_version = "8.0"
      use_dotnet_isolated_runtime = true  
    }

    cors {
      allowed_origins     = var.cors_origins
      support_credentials = true
    }
  }

  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

   app_settings = {
    FUNCTIONS_EXTENSION_VERSION  = "~4"
    WEBSITE_RUN_FROM_PACKAGE     = "1"

    AzureWebJobsStorage__accountName = azurerm_storage_account.function_storage.name
    AzureWebJobsStorage__credential = "managedidentity"
    
    AzureWebJobsStorage__blobServiceUri  = "https://${azurerm_storage_account.function_storage.name}.blob.core.windows.net"
    AzureWebJobsStorage__queueServiceUri = "https://${azurerm_storage_account.function_storage.name}.queue.core.windows.net"

    CosmosDb__AccountEndpoint  = module.cosmos.endpoint
    CosmosDb__Database         = module.cosmos.database_name
    CosmosDb__Container        = module.cosmos.container_name
  }
}

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
  principal_id         = azurerm_linux_function_app.backend.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

#FUNCTION QUEUE ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_queue_access" {
  principal_id         = azurerm_linux_function_app.backend.identity[0].principal_id
  role_definition_name = "Storage Queue Data Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

#COSMOSDB ROLE ASSIGNMENT
resource "azurerm_cosmosdb_sql_role_assignment" "function_cosmos_access" {
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = module.cosmos.name

  role_definition_id = "${module.cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"

  principal_id = azurerm_linux_function_app.backend.identity[0].principal_id

  scope = module.cosmos.id
}

#FILE ACCESS ROLE ASSIGNMENT
resource "azurerm_role_assignment" "function_file_access" {
  principal_id         = azurerm_linux_function_app.backend.identity[0].principal_id
  role_definition_name = "Storage File Data SMB Share Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

# AZURE APP REGISTRATION (GitHub OIDC identity)
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