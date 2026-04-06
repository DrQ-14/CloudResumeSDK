locals {
  storage_connection_string = "DefaultEndpointsProtocol=https;AccountName=${trimspace(var.storage_account_name)};AccountKey=${trimspace(var.storage_account_access_key)};EndpointSuffix=core.windows.net"
}