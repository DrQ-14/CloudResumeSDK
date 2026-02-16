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

#FRONTEND WEB APP
variable "frontend_sku" {
  description = "App Service Plan SKU for the frontend"
  type        = string
}