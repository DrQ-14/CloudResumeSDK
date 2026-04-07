variable "function_app_name" {}

variable "location" {}

variable "resource_group_name" {}

variable "function_plan_name" {
  type = string
}

variable "service_plan_sku" {
  type    = string
  default = "Y1"
}

variable "cors_origins" {
  type = list(string)
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type = string
}

variable "key_vault_secret_uri" {
  type = string
}

variable "storage_connection_string" {
  type      = string
  sensitive = true
}

variable "cosmos_endpoint" {}
variable "cosmos_database_name" {}
variable "cosmos_container_name" {}