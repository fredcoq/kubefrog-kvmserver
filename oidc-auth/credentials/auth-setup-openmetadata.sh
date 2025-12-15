#!/bin/bash

OIDC_CLIENT_ID="openmetadata-ID"
OIDC_CLIENT_SECRET=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

echo "apiVersion: v1
kind: Secret
metadata:
  name: oidc-secrets
  namespace: openmetadata
type: Opaque
stringData:
  openmetadata-oidc-client-id: $(echo -n $OIDC_CLIENT_ID)
  openmetadata-oidc-client-secret: $(echo -n $OIDC_CLIENT_SECRET)" \
    | kubeseal --format yaml \
    | tee ../../openmetadata/openmetadata-oidc-secret.yaml

yq eval -j -P ".clientId = \"${OIDC_CLIENT_ID}\" | .name = \"openmetadata\" | .secret = \"${OIDC_CLIENT_SECRET}\" | \
               .redirectUris[0] = \"https://openmetadata.kubefrog.ai/callback\" \
               " client-template.json | kubectl create secret generic -n openmetadata openmetadata-client  \
               --dry-run=client --from-file=client-template.json=/dev/stdin -o json | \
                kubeseal | yq eval -P > ../../openmetadata/openmetadata-client-file.yaml