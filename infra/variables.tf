#PRODUCTION/ENVIRONMENT
variable "project_name" {
  description = "Project name prefix used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., development, production)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be development (dev), staging, or production (prod)."
  }
}

variable "location" {
  description = "Azure region where all resources will be deployed"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must not be empty."
  }
}

variable "custom_domains" {
  description = "List of custom domains for the Static Web App"
  type        = list(string)
}

variable "cors_origins" {
  description = "List of allowed CORS origins for the Function App"
  type        = list(string)

  validation {
    condition     = alltrue([for o in var.cors_origins : length(o) > 0])
    error_message = "CORS origins must not contain empty strings."
  }
}