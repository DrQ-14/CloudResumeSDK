variable "webapp_name" {
  description = "Name of the Web App"
  type        = string

  validation {
    condition = (
      length(var.webapp_name) >= 1 &&
      length(var.webapp_name) <= 60 &&
      can(regex("^[a-zA-Z0-9-]+$", var.webapp_name))
    )
    error_message = "Web App name must be 1–60 characters and contain only letters, numbers, and hyphens."
  }
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

  validation {
    condition = (
      length(var.storage_account_name) >= 3 &&
      length(var.storage_account_name) <= 24 &&
      can(regex("^[a-z0-9]+$", var.storage_account_name))
    )

    error_message = "Storage account name must be 3–24 characters, lowercase letters and numbers only."
  }
}

variable "custom_domains" {
  description = "List of custom domains assigned to the Web App"
  type        = list(string)
}

variable "tags" {
  description = "Standard tags applied to all resources for cost tracking and organization"
  type        = map(string)
}