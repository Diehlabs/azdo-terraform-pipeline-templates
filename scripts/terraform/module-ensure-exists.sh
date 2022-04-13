#!/bin/sh
#
# module-ensure-exists.sh
#

generate_post_data() {
cat <<EOF
{
  "data": {
    "type":"registry-modules",
    "attributes": {
      "name": "${MODULE_FULL_NAME}",
      "provider":"${MODULE_PROVIDER}"
    }
  }
}
EOF
}

echo "Checking to see if module already exists at:"
echo $MODULE_VERIFY_URL

VERIFY_RESPONSE=$(curl \
--retry 5 \
--retry-delay 0 \
--retry-max-time 10 \
  --silent \
  -w '%{http_code}' \
  -o /dev/null \
  -H "Authorization: Bearer ${TF_TOKEN}" \
  $MODULE_VERIFY_URL)

echo "HTTP response from verify request: HTTP ${VERIFY_RESPONSE}"

if [ "${VERIFY_RESPONSE}" -eq 404 ]; then
  echo "Module does not exist, creating new at ${MODULE_CREATE_URL}"
  echo "Creating module with the following data: "
  echo $(generate_post_data) | jq -C .

  CREATE_RESPONSE=$(curl \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 10 \
    --silent \
    -H "Content-Type: application/vnd.api+json" \
    -H "Authorization: Bearer ${TF_TOKEN}" \
    -w '%{http_code}' \
    -o /dev/null \
    --request POST \
    --data "$(generate_post_data)" \
    $MODULE_CREATE_URL)
  echo "HTTP response from create module request: HTTP ${CREATE_RESPONSE}"

  if [ "${CREATE_RESPONSE}" != "201" ]; then
    echo "Unable to create module, recieved: HTTP ${CREATE_RESPONSE}"
    exit 1
  else
    echo "Successfully created module"
  fi
elif [ "${VERIFY_RESPONSE}" -eq 200 ]; then
  echo "Module already exists in registry, continuing."
else
  echo "Received an invalid HTTP response when verifying if module exists: HTTP ${VERIFY_RESPONSE}"
  exit 1
fi
