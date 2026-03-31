#FUNCTION APP CONSUMPTION PLAN
resource "azurerm_service_plan" "this" {
  name                = var.function_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type             = "Linux"
  sku_name            = "Y1"  # Consumption plan
}

#FUNCTION APP
resource "azurerm_linux_function_app" "this" {
   name                       = var.name
   location                   = var.location
   resource_group_name        = var.resource_group_name

   service_plan_id            = var.service_plan_sku

   storage_account_name       = var.storage_account_name

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
    WEBSITE_RUN_FROM_PACKAGE     = "1"

    AzureWebJobsStorage__accountName = var.storage_account_name
    AzureWebJobsStorage__credential = "managedidentity"
    
    AzureWebJobsStorage__blobServiceUri  = "https://${var.storage_account_name}.blob.core.windows.net"
    AzureWebJobsStorage__queueServiceUri = "https://${var.storage_account_name}.queue.core.windows.net"

    CosmosDb__AccountEndpoint  = var.cosmos_endpoint
    CosmosDb__Database         = var.cosmos_database_name
    CosmosDb__Container        = var.cosmos_container_name
  }
}