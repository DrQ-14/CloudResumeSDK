variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "consistency_level" {
  type = string
  default = "Session"
}

variable "partition_key_path" {
  type    = string
  default = "/id"
}