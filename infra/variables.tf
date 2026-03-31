#PRODUCTION/ENVIRONMENT
variable "project_name" {
  description = "Project name prefix"
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

variable "custom_domains" {
  type        = list(string)
  description = "List of custom domains for the static web app"
}

variable "cors_origins" {
  type        = list(string)
  description = "Allowed CORS origins for the function app"
}