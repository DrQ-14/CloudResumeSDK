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

  validation {
    condition = (
      length(var.cosmos_account_name) >= 3 &&
      length(var.cosmos_account_name) <= 44 &&
      can(regex("^[a-z0-9-]+$", var.cosmos_account_name)) &&
      !can(regex("--", var.cosmos_account_name)) &&
      !startswith(var.cosmos_account_name, "-") &&
      !endswith(var.cosmos_account_name, "-")
    )
    error_message = "Cosmos DB account name must be 3–44 characters, lowercase letters, numbers, and hyphens only. It cannot start/end with '-' or contain '--'."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
}

#variable "storage_account_access_key" {
#  description = "Access key for the Storage Account"
#  type        = string
#  sensitive   = true
#}

variable "tags" {
  description = "Standard tags applied to all resources for cost tracking and organization"
  type        = map(string)
}