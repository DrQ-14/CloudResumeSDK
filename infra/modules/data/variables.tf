variable "name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "location" {
  description = "Azure region where Cosmos DB will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "database_name" {
  description = "Name of the Cosmos DB database"
  type        = string
}

variable "container_name" {
  description = "Name of the Cosmos DB container"
  type        = string
}

variable "consistency_level" {
  description = "Cosmos DB consistency level"
  type        = string
  default     = "Session"

  validation {
    condition = contains([
      "Strong",
      "BoundedStaleness",
      "Session",
      "ConsistentPrefix",
      "Eventual"
    ], var.consistency_level)

    error_message = "Invalid Cosmos DB consistency level."
  }
}

variable "partition_key_path" {
  description = "Partition key path for the Cosmos DB container"
  type        = string
  default     = "/id"
}