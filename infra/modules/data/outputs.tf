output "account_id" {
  value = azurerm_cosmosdb_account.account.id
}

output "account_name" {
  value = azurerm_cosmosdb_account.account.name
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

output "cosmos_primary_key" {
  value     = azurerm_cosmosdb_account.account.primary_key
  sensitive = true
}