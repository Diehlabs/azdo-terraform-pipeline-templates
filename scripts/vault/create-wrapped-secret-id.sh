  #!/bin/sh
source "./scripts/vault/login-approle.sh"

# Get the Approle ID by name - to be used by the pipeline
req_url="${VAULT_ADDR}/v1/auth/approle/role/${PIPELINE_APPROLE}/role-id"
ROLE_ID_RESPONSE=$(curl  \
  --header "X-Vault-Token: ${TE_TOKEN}" \
  --request GET \
  --silent \
  $req_url)

echo "Request URL: $req_url"
echo "Pipeline Approle ID lookup request ID:"
echo $ROLE_ID_RESPONSE | jq -C .request_id
ROLE_ID=$(echo $ROLE_ID_RESPONSE | jq -r .data.role_id)
if [ $ROLE_ID == null ]; then
  echo "Result was null, exiting."
  exit 1
else
  echo "##vso[task.setvariable variable=APPROLE_ROLE_ID;isOutput=true]${ROLE_ID}"
fi
echo "------------------------------"

# Generate a wrapped response containing the secret id for the specified approle using the pipeline (trusted entity)
req_url="${VAULT_ADDR}/v1/auth/approle/role/${PIPELINE_APPROLE}/secret-id"
WRAP_RESPONSE=$(curl  \
  --header "X-Vault-Token: ${TE_TOKEN}" \
  --header "X-Vault-Wrap-TTL: 500s" \
  --request POST \
  --silent \
  $req_url)
echo "Request URL: $req_url"
echo "Wrapped Secret ID accessor:"
echo $WRAP_RESPONSE | jq -C .wrap_info.accessor

WRAP_RESULT=$(echo $WRAP_RESPONSE | jq -r .wrap_info.token)
if [ $WRAP_RESULT == null ]; then
  echo "Result was null, exiting."
  exit 1
else
  vwr_path="${AGENT_TEMPDIRECTORY}/vault_wrapped_response"
  echo $WRAP_RESULT > $vwr_path
  echo "##vso[task.setvariable variable=WRAPPED_TOKEN_FILE_PATH;isOutput=true]${vwr_path}"
fi
