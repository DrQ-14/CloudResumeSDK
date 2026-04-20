#CORE MODULE
module "core" {
  source = "./modules/core"

  resource_group_name   = local.rg_name
  location              = var.location
  storage_account_name  = local.storage_name
  webapp_name           = local.webapp_name
  custom_domains        = var.custom_domains

  tags = local.tags
}

#DATA MODULE
module "data" {
  source = "./modules/data"
  #depends_on = [module.core]

  name                = local.cosmos_account_name
  location            = module.core.location
  resource_group_name = module.core.resource_group_name

  database_name  = local.cosmos_database_name
  container_name = local.cosmos_container_name

  tags = local.tags
}

#COMPUTE MODULE
module "compute" {
  source = "./modules/compute"
  #depends_on = [module.core, module.data]

  function_app_name   = local.function_name
  function_plan_name  = local.function_plan_name

  application_insights_name = local.appinsights_name

  storage_connection_string = module.core.storage_connection_string

  location            = module.core.location
  resource_group_name = module.core.resource_group_name

  storage_account_name       = module.core.storage_account_name
  #storage_account_access_key = module.core.storage_account_access_key

  cosmos_endpoint       = module.data.endpoint
  cosmos_database_name  = module.data.database_name
  cosmos_container_name = module.data.container_name

  cors_origins = var.cors_origins

  tags = local.tags
}

#SECURITY MODULE
module "security" {
  source = "./modules/security"
  #depends_on = [module.core, module.compute, module.data]

  location = module.core.location

  storage_account_name       = module.core.storage_account_name
  #storage_account_access_key = module.core.storage_account_access_key

  function_principal_id = module.compute.principal_id
  storage_account_id = module.core.storage_account_id

  cosmos_account_id  = module.data.account_id
  cosmos_account_name = module.data.account_name

  resource_group_name = module.core.resource_group_name

  tags = local.tags
}