#!/bin/sh
#
# module-create-new-version.sh
#

generate_post_data() {
cat <<EOF
{
  "data": {
    "type": "registry-module-versions",
    "attributes": {
      "version": "${MODULE_VERSION_NUMBER}"
    }
  }
}
EOF
}

echo "Creating new module version at: ${MODULE_NEW_VER_URL}"
echo "Creating new module version with the following data: "
echo $(generate_post_data) | jq -C .
CREATE_RESPONSE=$(curl \
  --retry 5 \
  --retry-delay 0 \
  --retry-max-time 10 \
  --silent \
  -H "Authorization: Bearer ${TF_TOKEN}" \
  -H "Content-Type: application/vnd.api+json" \
  -w '|%{http_code}' \
  --request POST \
  --data "$(generate_post_data)" \
  $MODULE_NEW_VER_URL)
IFS='|' read  -r -a array <<< "$CREATE_RESPONSE"
CREATE_RESPONSE_BODY=${array[0]}
CREATE_RESPONSE_CODE=${array[1]}
echo "HTTP response from create new module version request: HTTP ${CREATE_RESPONSE_CODE}"
echo "BODY:"
echo $CREATE_RESPONSE_BODY | jq -C .
if [ "${CREATE_RESPONSE_CODE}" != "201" ]; then
  echo "Unable to create new module version, recieved: HTTP ${CREATE_RESPONSE_CODE}"
  echo $CREATE_RESPONSE_BODY | jq .
  exit 1
else
  echo "Successfully created new module version"
  MOD_UPLOAD_URL=$(echo ${CREATE_RESPONSE_BODY} | jq -r .data.links.upload)
  echo "Upload URL: ${MOD_UPLOAD_URL}"
  echo "##vso[task.setvariable variable=MOD_UPLOAD_URL]${MOD_UPLOAD_URL}"
fi
