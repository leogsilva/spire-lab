#!/bin/bash

# THUMBPRINT=$(echo | openssl s_client -connect $1:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}')
THUMBPRINT="1d600a429282b1dcd1de20f0f8e1e0db5cdc54a9"
THUMBPRINT_JSON="{\"thumbprint\": \"${THUMBPRINT}\"}"
echo $THUMBPRINT_JSON