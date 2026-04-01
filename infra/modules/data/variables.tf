variable "name" {}
variable "location" {}
variable "resource_group_name" {}

variable "database_name" {}
variable "container_name" {}

variable "consistency_level" {
  default = "Session"
}