terraform {
  backend "azurerm" {
    storage_account_name   = "hamesmith",
    container_name         = "terraform",
    key                    = "azd/azdremotetest.tfstate",
    resource_group_name    = "sandbox-rg"
  }
}
