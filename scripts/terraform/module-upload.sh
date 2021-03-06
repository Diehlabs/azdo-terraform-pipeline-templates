#!/bin/sh
#
# module-create-new-version.sh
#

MODULE_ARCHIVE_FILE="${AGENT_TEMPDIRECTORY}/${MOD_FILE_NAME}"

if [ ! -f "${MODULE_ARCHIVE_FILE}" ]; then
    echo "Could not find module archive file for upload. Check the build stage and the download step in this stage."
    exit 1
fi

echo "Module version upload URL:"
echo $MOD_UPLOAD_URL

MY_OUTPUT=$(curl \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 10 \
    -H "Authorization: Bearer ${TF_TOKEN}" \
    -H "Content-Type: application/vnd.api+json" \
    --request PUT \
    --data-binary @"${MODULE_ARCHIVE_FILE}" \
    $MOD_UPLOAD_URL)

echo $MY_OUTPUT | jq -C .
