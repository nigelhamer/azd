terraform {
  backend "azurerm" {
    storage_account_name   = "hamersmith",
    container_name         = "terraform",
    key                    = "azd/azdremotetest.tfstate",
    resource_group_name    = "sandbox-rg",
    client_id              = "f28cacdb-8acf-4d9b-8050-a9e2d6dacdc9",
    tenant_id              = "dbba3d9f-8b34-49b7-878a-d3d0d70056ce"
  }
}