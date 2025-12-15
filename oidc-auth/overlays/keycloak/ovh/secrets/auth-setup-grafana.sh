# #!/bin/bash
# OIDC_CLIENT_ID=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
OIDC_CLIENT_ID="grafana-client"
OIDC_CLIENT_SECRET=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

yq eval -j -P ".clientId = \"${OIDC_CLIENT_ID}\" | .secret = \"${OIDC_CLIENT_SECRET}\" | \
               .redirectUris[0] = \"https://grafana.kubefrog.fr/login/generic_oauth\" \
               " client-template.json | kubectl create secret generic -n auth grafana-client  \
               --dry-run=client --from-file=client-template.json=/dev/stdin -o json | \
                kubeseal | yq eval -P > grafana-client-secret.yaml
