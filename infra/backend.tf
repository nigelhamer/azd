terraform {
  backend "azurerm" {
    storage_account_name   = "${RS_STORAGE_ACCOUNT}",
    container_name         = "${RS_CONTAINER_NAME}",
    key                    = "azd/azdremotetest.tfstate",
    resource_group_name    = "${RS_RESOURCE_GROUP}",
    client_id              = "${AZURE_TENANT_ID}",
    tenant_id              = "${AZURE_SUBSCRIPTION_ID}"
  }
}
