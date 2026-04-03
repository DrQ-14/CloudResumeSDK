output "cosmos_account_name" {
  value = azurerm_cosmosdb_account.account.name
}

output "cosmos_account_id" {
  value = azurerm_cosmosdb_account.account.id
}

output "endpoint" {
  value = azurerm_cosmosdb_account.account.endpoint
}

output "database_name" {
  value = azurerm_cosmosdb_sql_database.sql_database.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.sql_container.name
}