  #!/bin/sh
if [ -z ${TE_ID} ] || [ -z ${TE_SEC} ];
then
  echo "Required environment variables not set. Ensure the below variables are populated."
  echo "TE_ID: ${TE_ID}"
  echo "TE_SEC: ${TE_SEC}"
  exit 1
fi

generate_token_auth_data() {
cat <<EOF
{
  "token_policies": [
    "default"
    ],
  "ttl":"10s"
}
EOF
}

# Create auth token for unwrapping
TOKEN_RESPONSE=$(curl \
  --retry 5 \
  --retry-delay 0 \
  --retry-max-time 10 \
  --header "X-Vault-Token: ${LOGIN_RESULT}" \
  --request POST \
  --data "$(generate_token_auth_data)" \
  "${VAULT_ADDR}/v1/auth/token/create")
echo "Create auth token response:"
echo $TOKEN_RESPONSE | jq -C
TOKEN_RESULT=$(echo $TOKEN_RESPONSE | jq -r .auth.client_token)
echo "------------------------------"

generate_unwrap_data() {
cat <<EOF
{
  "token": "${WRAP_RESULT}"
}
EOF
}

# Auth with the temp token and unwrap the secret id
UNWRAP_RESPONSE=$(curl \
--retry 5 \
--retry-delay 0 \
--retry-max-time 10 \
  --header "X-Vault-Token: ${TOKEN_RESULT}" \
  --request POST \
  --data "$(generate_unwrap_data)" \
  "${VAULT_ADDR}/v1/sys/wrapping/unwrap")
echo "Unwrap Secret ID response:"
echo $UNWRAP_RESPONSE | jq -C
UNWRAP_RESULT=$(echo $UNWRAP_RESPONSE | jq -r .data.approle_secret)

echo "Approle ID: ${ROLE_ID}"
echo "Secret ID: ${UNWRAP_RESULT}"
