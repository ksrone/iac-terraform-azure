resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_linux_function_app" "example" {
  name                      = var.function_app_name
  location                  = azurerm_resource_group.example.location
  resource_group_name       = azurerm_resource_group.example.name
  app_service_plan_id       = azurerm_app_service_plan.example.id
  storage_account_name      = azurerm_storage_account.example.name
  os_type                   = "Linux"
  runtime_stack             = "node"
  functions_version         = "~3"
}

resource "azurerm_function_app_function" "example" {
  name                      = var.function_name
  resource_group_name       = azurerm_resource_group.example.name
  function_app_name         = azurerm_linux_function_app.example.name
  storage_account_name      = azurerm_storage_account.example.name
  app_service_plan_id       = azurerm_app_service_plan.example.id
  os_type                   = azurerm_linux_function_app.example.os_type
  runtime_stack             = azurerm_linux_function_app.example.runtime_stack
  functions_version         = azurerm_linux_function_app.example.functions_version
}
