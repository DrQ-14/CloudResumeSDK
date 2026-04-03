#FUNCTION MODULE
module "compute" {
  source = "./modules/compute"

  function_app_name                = local.function_name
  location            = var.location
  ---resource_group_name = azurerm_resource_group.rg.name

  function_plan_name = local.function_plan_name

  ---storage_account_name       = azurerm_storage_account.function_storage.name
  ---storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key

  cosmos_endpoint       = module.data.endpoint
  cosmos_database_name  = module.data.database_name
  cosmos_container_name = module.data.container_name

  cors_origins = var.cors_origins

}

#COSMOSDB MODULE
module "data" {
  source = "./modules/data"

  name                = local.cosmos_account_name
  location            = var.location
  ---resource_group_name = azurerm_resource_group.rg.name

  database_name  = local.cosmos_database_name
  container_name = local.cosmos_container_name
}