
#!/bin/zsh

#chmod +x setupShell.zsh

# Set environment variables
export AZURE_ENV_NAME="DEV"
export AZURE_LOCATION="uksouth"
export AZURE_SUBSCRIPTION_ID="8f8d6d66-dc06-459a-b140-3de74e5f2fe5"
export AZURE_TENANT_ID="dbba3d9f-8b34-49b7-878a-d3d0d70056ce"
export RS_CONTAINER_NAME="terraformdev"
export RS_RESOURCE_GROUP="sandbox-rg"
export RS_STORAGE_ACCOUNT="hamesmith"
export ARM_SUBSCRIPTION_ID="8f8d6d66-dc06-459a-b140-3de74e5f2fe5"
export ARM_TENANT_ID="dbba3d9f-8b34-49b7-878a-d3d0d70056ce"
export ARM_CLIENT_ID="2642bb1d-c595-4de5-a2f8-c7bf5e51c8b4"

# Display a message to confirm the variables are set
echo "Environment variables set successfully."

#. setupShell.zsh