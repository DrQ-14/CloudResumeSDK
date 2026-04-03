output "id" {
  value = azurerm_linux_function_app.function_app.id
}

output "principal_id" {
  value = azurerm_linux_function_app.function_app.identity[0].principal_id
}

output "default_hostname" {
  value = azurerm_linux_function_app.function_app.default_hostname
}

output "service_plan_id" {
  value = azurerm_service_plan.service_plan.id
}

output "function_app_name" {
  value = azurerm_linux_function_app.function_app.name
}