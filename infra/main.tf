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
   storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

   site_config {
    application_stack {
      dotnet_version = "8.0"
      use_dotnet_isolated_runtime = "true"
    }
   }

   app_settings = {
    FUNCTIONS_EXTENSION_VERSION  = "~4"
    WEBSITE_RUN_FROM_PACKAGE     = "1"

    AzureWebJobsStorage = var.azure_webjobs_storage

    CosmosDb__ConnectionString = var.cosmosdb_connection_string
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