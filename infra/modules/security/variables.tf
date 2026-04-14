variable "location" {
  description = "Azure region (used for consistency across modules)"
  type        = string
}

variable "function_principal_id" {
  description = "Principal ID of the Function App's managed identity"
  type        = string
}

variable "storage_account_id" {
  description = "Resource ID of the Storage Account"
  type        = string
}

variable "cosmos_account_id" {
  description = "Resource ID of the Cosmos DB account"
  type        = string
}

variable "cosmos_account_name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key for the Storage Account"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Standard tags applied to all resources for cost tracking and organization"
  type        = map(string)
}