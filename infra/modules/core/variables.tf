variable "webapp_name" {
  description = "Name of the Web App"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the Storage Account used by the Web App"
  type        = string
}

variable "custom_domains" {
  description = "List of custom domains assigned to the Web App"
  type        = list(string)
}

variable "tags" {
  description = "Standard tags applied to all resources for cost tracking and organization"
  type        = map(string)
}