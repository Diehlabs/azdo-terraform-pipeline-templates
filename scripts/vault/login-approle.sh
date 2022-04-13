  #!/bin/sh
if [ -z ${TE_ID} ] || [ -z ${TE_SEC} ];
then
  echo "Required environment variables not set. Ensure the below variables are populated."
  echo "TE_ID: ${TE_ID}"
  echo "TE_SEC: ${TE_SEC}"
  exit 1
fi

req_url="${VAULT_ADDR}/v1/auth/approle/login"

generate_post_data() {
cat <<EOF
{
  "role_id": "${TE_ID}",
  "secret_id": "${TE_SEC}"
}
EOF
}

LOGIN_RESPONSE=$(curl  \
  --request POST \
  --silent \
  --data "$(generate_post_data)" \
  $req_url)

echo "Request URL: $req_url"
echo "Trusted entity login accessor:"
echo $LOGIN_RESPONSE | jq -C .auth.accessor

if [ $LOGIN_RESPONSE == null ]; then
  echo "Result was null, exiting."
  exit 1
else
  TE_TOKEN=$(echo $LOGIN_RESPONSE | jq -r .auth.client_token)
fi

echo "------------------------------"
