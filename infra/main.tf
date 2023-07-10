locals {
  product_prefix = "ph"
  tags           = { azd-env-name : lower(var.environment_name) }
  sha            = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
}
# Implements a set of methodologies to apply consistent resource naming using the default Microsoft Cloud Adoption Framework for Azure recommendations
# https://github.com/aztfmod/terraform-provider-azurecaf/blob/main/docs/resources/azurecaf_name.md
resource "azurecaf_name" "rg_name" {
  name          = "${local.product_prefix}-${var.service_name}"
  resource_type = "azurerm_resource_group"
  suffixes      = [lower(var.environment_name)]
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "appinsights_name" {
  name          = "${local.product_prefix}-${var.service_name}"
  resource_type = "azurerm_application_insights"
  suffixes      = [lower(var.environment_name)]
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "appserviceplan_name" {
  name          = "${local.product_prefix}-${var.service_name}"
  resource_type = "azurerm_app_service"
  suffixes      = [lower(var.environment_name)]
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "functionapp_name" {
  name          = "${local.product_prefix}-${var.service_name}"
  resource_type = "azurerm_app_service"
  suffixes      = [lower(var.environment_name)]
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "storageacc_name" {
  name          = "${local.product_prefix}-${var.service_name}"
  resource_type = "azurerm_storage_account"
  suffixes      = [lower(var.environment_name)]
  random_length = 0
  clean_input   = true
}



# Deploy resource group
resource "azurerm_resource_group" "rg" {
  name     = azurecaf_name.rg_name.result
  location = var.location
  // Tag the resource group with the azd environment name
  // This should also be applied to all resources created in this module
  tags = { azd-env-name : var.environment_name }
}

resource "azurerm_storage_account" "functionapp_storage" {
  name                     = azurecaf_name.storageacc_name.result
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Deploy application insights
resource "azurerm_application_insights" "appinsights" {
  name                = azurecaf_name.appinsights_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = azurecaf_name.appserviceplan_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_linux_function_app" "functionapp" {
  name                       = azurecaf_name.functionapp_name.result
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_app_service_plan.appserviceplan.id
  storage_account_name       = azurerm_storage_account.functionapp_storage.name
  storage_account_access_key = azurerm_storage_account.functionapp_storage.primary_access_key
  # Required for AZD to know where to deploy
  tags = { azd-service-name : "app" }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "dotnet"
    "FUNCTIONS_EXTENSION_VERSION"    = "~4"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights.instrumentation_key,
    "ContainerName"                  = "pallethotel-contract",
  }
  site_config {
  }
}

