variable "function_app_name" {
  description = "Name of the Azure Function App"
  type        = string

  validation {
    condition     = length(trimspace(var.function_app_name)) > 0
    error_message = "Function App name cannot be empty."
  }
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "Resource Group name cannot be empty."
  }
}

variable "function_plan_name" {
  description = "Name of the Function App Service Plan"
  type        = string

  validation {
    condition     = length(trimspace(var.function_plan_name)) > 0
    error_message = "Function Plan name cannot be empty."
  }
}

variable "service_plan_sku" {
  description = "SKU for the Function App Service Plan"
  type        = string
  default = "Y1"

  validation {
    condition     = contains(["Y1", "B1", "S1", "P1v3"], var.service_plan_sku)
    error_message = "Unsupported SKU selected."
  }
}

variable "cors_origins" {
  description = "List of allowed CORS origins for the Function App"
  type        = list(string)
}

variable "storage_account_name" {
  description = "Name of the Storage Account used by the Function App"
  type        = string
}

#variable "storage_account_access_key" {
#  description = "Access key for the Storage Account"
#  type        = string
#}

variable "storage_connection_string" {
  description = "Connection string for the Storage Account"
  type        = string
  sensitive   = true
}

variable "application_insights_name" {
  description = "Name of the Application Insights instance"
  type        = string

  validation {
    condition     = length(trimspace(var.application_insights_name)) > 0
    error_message = "Application Insights name cannot be empty."
  }
}

variable "cosmos_endpoint" {
  description = "Endpoint URL for Cosmos DB account"
  type        = string
}

variable "cosmos_database_name" {
  description = "Name of the Cosmos DB database"
  type        = string

  validation {
    condition     = length(trimspace(var.cosmos_database_name)) > 0
    error_message = "Cosmos Database name cannot be empty."
  }
}

variable "cosmos_container_name" {
  description = "Name of the Cosmos DB container"
  type        = string

  validation {
    condition     = length(trimspace(var.cosmos_container_name)) > 0
    error_message = "Cosmos Container name cannot be empty."
  }
}

variable "tags" {
  description = "Standard tags applied to all resources for cost tracking and organization"
  type        = map(string)
}