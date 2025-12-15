#!/bin/bash

OIDC_CLIENT_ID_1="d621b7700a2e2cbd6cee7136898273f0"
OIDC_CLIENT_SECRET_1="5748d839e83c3bb97edd57f815c26eeaca03eabcdbe240df435c16637902219b"


yq eval -j -P ".web.client_id = \"${OIDC_CLIENT_ID_1}\" | .web.client_secret = \"${OIDC_CLIENT_SECRET_1}\" \
               " superset-client-template.json | kubectl create secret generic -n superset superset-oidc-keycloak-config  --dry-run=client --from-file=superset-client.json=/dev/stdin -o json | kubeseal | yq eval -P > superset-client-secret.yaml
