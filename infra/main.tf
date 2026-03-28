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
  static_web_app_id = azurerm_static_web_app.frontend.id
  domain_name       = "tanager-solutions.com"
  validation_type   = "dns-txt-token"
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
   #storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

  identity {
    type = "SystemAssigned"
  }

   site_config {
    application_stack {
      dotnet_version = "8.0"
      use_dotnet_isolated_runtime = true  
    }

    cors {
        allowed_origins     = [
                  "http://localhost:8000",
                  "https://black-pebble-032af530f.1.azurestaticapps.net",
                  "https://www.tanager-solutions.com",
                ]
        support_credentials = true
      }
   }

   app_settings = {
    FUNCTIONS_EXTENSION_VERSION  = "~4"
    WEBSITE_RUN_FROM_PACKAGE     = "1"

    AzureWebJobsStorage__accountName = azurerm_storage_account.function_storage.name
    AzureWebJobsStorage__credential = "managedidentity"

    CosmosDb__AccountEndpoint  = azurerm_cosmosdb_account.cosmos.endpoint
    CosmosDb__Database         = local.cosmos_database_name
    CosmosDb__Container        = local.cosmos_container_name
  }
}

#COSMOS DB ACCOUNT
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = local.cosmos_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

#COSMOS SQL DATABASE
resource "azurerm_cosmosdb_sql_database" "db" {
  name                = local.cosmos_database_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

#COSMOS SQL CONTAINER
resource "azurerm_cosmosdb_sql_container" "container" {
  name                = local.cosmos_container_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name

  partition_key_paths = ["/id"]
}

#Function Storage Role Assignment
resource "azurerm_role_assignment" "function_storage_access" {
  principal_id         = azurerm_linux_function_app.backend.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

#Function Queue Role Assignment
resource "azurerm_role_assignment" "function_queue_access" {
  principal_id         = data.azurerm_linux_function_app.backend.identity[0].principal_id
  role_definition_name = "Storage Queue Data Contributor"
  scope                = azurerm_storage_account.function_storage.id
}

#CosmosDB Role Assignment
resource "azurerm_cosmosdb_sql_role_assignment" "function_cosmos_access" {
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name

  role_definition_id = "${azurerm_cosmosdb_account.cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"

  principal_id = azurerm_linux_function_app.backend.identity[0].principal_id

  scope = azurerm_cosmosdb_account.cosmos.id
}

#Function App Data Reference
data "azurerm_linux_function_app" "backend" {
  name                = azurerm_linux_function_app.backend.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_linux_function_app.backend
  ]
}