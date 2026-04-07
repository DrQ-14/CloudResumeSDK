#COSMOS DB ACCOUNT
resource "azurerm_cosmosdb_account" "account" {
  name = var.name
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

  identity {
    type = "SystemAssigned"
  }
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