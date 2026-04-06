variable "location" {
  type = string
}

variable "function_principal_id" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "cosmos_account_id" {
  type = string
}

variable "cosmos_account_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "ky_vault_name" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "debug_vars" {
  value = {
    account_name_set = var.storage_account_name != ""
    key_set          = var.storage_account_access_key != ""
    key_length       = length(var.storage_account_access_key)
  }
}