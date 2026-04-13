#FUNCTION APP CONSUMPTION PLAN
resource "azurerm_service_plan" "service_plan" {
  name                = var.function_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type             = "Linux"
  sku_name            = var.service_plan_sku
}

  resource "azurerm_application_insights" "appi" {
  name                = "resume-dev-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

#FUNCTION APP
resource "azurerm_linux_function_app" "function_app" {
   name                       = var.function_app_name
   location                   = var.location
   resource_group_name        = var.resource_group_name

   service_plan_id            = azurerm_service_plan.service_plan.id

   storage_account_name       = var.storage_account_name

  storage_account_access_key  = var.storage_account_access_key

  identity {
    type = "SystemAssigned"
  }

   site_config {
    application_stack {
      dotnet_version = "8.0"
      use_dotnet_isolated_runtime = true  
    }

    cors {
      allowed_origins     = var.cors_origins
      support_credentials = true
    }
  }

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION  = "~4"
    WEBSITE_RUN_FROM_PACKAGE     = "0"

    #AzureWebJobsStorage = trimspace(var.storage_connection_string)
    
    AzureWebJobsStorage__accountName = var.storage_account_name
    storage_uses_managed_identity = true
    #AzureWebJobsStorage__credential = "managedidentity"
    
    #AzureWebJobsStorage__blobServiceUri  = "https://${var.storage_account_name}.blob.core.windows.net"
    #AzureWebJobsStorage__queueServiceUri = "https://${var.storage_account_name}.queue.core.windows.net"

    CosmosDb__AccountEndpoint  = var.cosmos_endpoint
    CosmosDb__Database         = var.cosmos_database_name
    CosmosDb__Container        = var.cosmos_container_name

    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.appi.connection_string
    AzureWebJobsFeatureFlags = "EnableWorkerIndexing"
  }
}