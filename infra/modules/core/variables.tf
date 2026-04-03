variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "static_web_app_name" {
  type = string
}

variable "custom_domains" {
  type = list(string)
}