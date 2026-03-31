variable "name" {}

variable "location" {}

variable "resource_group_name" {}

variable "service_plan_sku" {
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

variable "cosmos_endpoint" {}
variable "cosmos_database_name" {}
variable "cosmos_container_name" {}