  #!/bin/sh
source "./scripts/vault/login-approle.sh"

# Request a new TFE API token using Vault role $VAULT_ROLE_NAME
req_url="${VAULT_ADDR}/v1/terraform/creds/${VAULT_ROLE_NAME}"
ROLE_ID_RESPONSE=$(curl  \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request GET \
  --silent \
  $req_url)

echo "Request URL: $req_url"
echo "Terraform Enterprise token ID:"
echo $ROLE_ID_RESPONSE | jq -C .data.token_id
tfe_token=$(echo $ROLE_ID_RESPONSE | jq -r .data.token)
if [ $ROLE_ID == null ]; then
  echo "Result was null, exiting."
  exit 1
else
  echo "##vso[task.setvariable variable=TFE_TOKEN;isOutput=true]${tfe_token}"
fi
