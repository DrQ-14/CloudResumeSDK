#COSMOS DB ACCOUNT
resource "azurerm_cosmosdb_account" "account" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}

#COSMOS SQL DATABASE
resource "azurerm_cosmosdb_sql_database" "database" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.account.name
}

#COSMOS SQL CONTAINER
resource "azurerm_cosmosdb_sql_container" "container" {
  name                = var.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.account.name
  database_name       = azurerm_cosmosdb_sql_database.database.name

  partition_key_paths = [var.partition_key_path]
}

#INTEGRATION TEST DATABASE AND SQL CONTAINER

resource "azurerm_cosmosdb_sql_database" "app_db" {
  name                = "app-db"
  resource_group_name = var.resource_group_name
  account_name        = var.cosmos_account_name
}

resource "azurerm_cosmosdb_sql_container" "counters" {
  name                = "counters"
  resource_group_name = var.resource_group_name
  account_name        = var.cosmos_account_name
  database_name       = azurerm_cosmosdb_sql_database.app_db.name

  partition_key_path = "/id"
  throughput         = 400
}