output "name" {
  value = azurerm_cosmosdb_account.account.name
}

output "id" {
  value = azurerm_cosmosdb_account.account.id
}

output "endpoint" {
  value = azurerm_cosmosdb_account.account.endpoint
}

output "database_name" {
  value = azurerm_cosmosdb_sql_database.database.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.container.name
}