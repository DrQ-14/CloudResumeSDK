#PRODUCTION/ENVIRONMENT
variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID for this deployment"
  type        = string
}


variable "environment" {
  description = "Deployment environment (development/production/etc)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "azure_webjobs_storage" {
  type      = string
  sensitive = true
}

variable "cosmosdb_connection_string" {
  type      = string
  sensitive = true
}