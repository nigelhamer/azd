terraform {
  backend "azurerm" {
    storage_account_name   = "hamersmith",
    container_name         = "terraform",
    key                    = "azd/azdremotetest.tfstate",
    resource_group_name    = "sandbox-rg",
    client_id              = "de8d9e87-3921-45e8-923a-7bc42a5e1835",
    tenant_id              = "dbba3d9f-8b34-49b7-878a-d3d0d70056ce"
  }
}
