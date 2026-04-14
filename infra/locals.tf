locals {
    #Base prefixes
    prefix = "${var.project_name}-${var.environment}"
    storage_prefix = "${var.project_name}${var.environment}" #for globally unique storage

    #Resource names
    rg_name = "${local.prefix}-rg"
    webapp_name ="${local.prefix}-frontend"
    function_plan_name = "${local.prefix}-func-plan"
    function_name = "${local.prefix}-function"
    appinsights_name = "${local.prefix}-appinsights"

    storage_name = lower("${local.storage_prefix}funcstor") #lowercase formatting for Azure
    
    cosmos_account_name = "${local.prefix}-cosmos"
    cosmos_database_name = "resume-db"
    cosmos_container_name = "counter"

    
  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}