#!/bin/sh

if [ -n "$TF_CLI_VERSION" ]; then
    echo "TF_CLI_VERSION variable is set: ${TF_CLI_VERSION}"
    echo "This repository requires Terraform version ${TF_CLI_VERSION}"
else
    err_msg="TF_CLI_VERSION variable is not set!"
    echo "You MUST include a TF_CLI_VERSION variable in this pipeline!"
    echo ${err_msg}
    exit 1
fi

echo "Terraform CLI version download URL:"
echo "${TF_DL_URL}"

MY_OUTPUT=$(curl \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 10 \
    --request GET \
    -o "${AGENT_TEMPDIRECTORY}/terraform.zip" \
    ${TF_DL_URL})

echo $MY_OUTPUT | jq -C .
unzip "${AGENT_TEMPDIRECTORY}/terraform.zip" &&\
chmod +x "${AGENT_TEMPDIRECTORY}/terraform" &&\
rm "${AGENT_TEMPDIRECTORY}/terraform.zip"
