# #!/bin/bash
# OIDC_CLIENT_ID=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
OIDC_CLIENT_ID="kiali-client"
OIDC_CLIENT_SECRET=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

kubectl create secret generic kiali -n monitoring  --from-literal=oidc-secret=${OIDC_CLIENT_SECRET} --dry-run=client -o yaml | kubeseal | yq eval -P > kiali-oidc-secret.yaml


yq eval -j -P ".clientId = \"${OIDC_CLIENT_ID}\" | .secret = \"${OIDC_CLIENT_SECRET}\"  \
               " client-template.json | kubectl create secret generic -n auth kiali-client --dry-run=client --from-file=client-template.json=/dev/stdin -o json | kubeseal | yq eval -P > kiali-client-secret.yaml
