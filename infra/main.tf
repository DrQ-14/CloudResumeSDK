# RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

##SERVICE PLAN (Frontend)
#resource "azurerm_service_plan" "frontend_plan" {
#  name                = "${local.prefix}-frontend-plan"
#  location            = var.location
#  resource_group_name = azurerm_resource_group.rg.name
#  os_type             = "Linux"
#  sku_name            = var.frontend_sku
#}

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

   site_config {}
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