#!/bin/bash
setPermission() {
    permission=$1

    echo "Assigning - $permission"

    appRoleId=$(az ad sp list --display-name "Microsoft Graph" --query "[0].appRoles[?value=='$permission' && contains(allowedMemberTypes, 'Application')].id" --output tsv)
    echo "appRoleId: $appRoleId"
    body="{'principalId':'$spId','resourceId':'$graphResourceId','appRoleId':'$appRoleId'}"
    az rest --method post --uri $uri --body $body --headers "Content-Type=application/json"

    echo "Completed - $permission"
}

az account set --subscription "Azure Subscription TPH 1"

# SYSTEM MANAGED IDENTITY
# Find the PrincipalId of the Identity Attached to the App Services
# webAppName="<WebAppName>"
# spId=$(az resource list -n $webAppName --query [*].identity.principalId --out tsv)
# echo "$webAppName PrincipalId: $spId"

# USER MANAGED IDENTITY
# Find the Id of the Identity Attached to the App Services
managedIdentityName="ph-contract-dev"
spId=$(az ad sp list --display-name $managedIdentityName --query [0].id --out tsv)
echo "$managedIdentityName Id: $spId"

# Find the Id of the Graph Resource to the App Services
graphResourceId=$(az ad sp list --display-name "Microsoft Graph" --query [0].id --out tsv)
echo "Microsoft Graph id: $graphResourceId"

# Create the URI
uri=https://graph.microsoft.com/v1.0/servicePrincipals/$spId/appRoleAssignments
echo "Uri: $uri"

setPermission "Mail.Read"
setPermission "Mail.ReadBasic"
setPermission "Mail.ReadBasic.All"
setPermission "Mail.ReadWrite"
setPermission "Mail.Send"
#setPermission "User.Read"

