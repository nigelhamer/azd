#!/bin/bash
# remember to run chmod +x localTerraformPlan.sh
# to run: ./localTerraformPlan.sh
export AZURE_ENV_NAME=DEV
export SERVICE_NAME=demo

source ../.azure/$AZURE_ENV_NAME/.env

# The following commented out code would be better as we'd be able to deal with AZD env changes more gracefully
# but the source command does not seem to work even though the command is returned the same as what is in the .env file

# Switch the AZD environment and load the configuration as environment variables
# azd env select $AZURE_ENV_NAME
# source <(azd env get-values --no-prompt)

echo "AZURE_ENV_NAME:$AZURE_ENV_NAME"

cd ../infra

# Dynamically configure the backend
terraform init \
    -backend-config="storage_account_name=$RS_STORAGE_ACCOUNT" \
    -backend-config="container_name=$RS_CONTAINER_NAME" \
    -backend-config="key=$SERVICE_NAME/remotetest.tfstate" \
    -backend-config="resource_group_name=$RS_RESOURCE_GROUP" \
    -backend-config="subscription_id=$AZURE_SUBSCRIPTION_ID" \
    -backend-config="tenant_id=$AZURE_TENANT_ID" \
    -backend-config="use_oidc=true" 

terraform fmt

terraform validate

# Pass the values for the variables terraform needs
terraform plan \
    -var="environment_name=$AZURE_ENV_NAME" \
    -var="location=$AZURE_LOCATION" \
    -var="service_name=$SERVICE_NAME" 
