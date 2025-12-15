# #!/bin/bash
# OIDC_CLIENT_ID=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
OIDC_CLIENT_ID="druid-client"
OIDC_CLIENT_SECRET=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

yq eval -j -P ".clientId = \"${OIDC_CLIENT_ID}\" | .secret = \"${OIDC_CLIENT_SECRET}\" | \
               .redirectUris[0] = \"http://druid.kubefrog.fr/druid-ext/druid-pac4j\" \
               " client-template.json | kubectl create secret generic -n auth druid-client  \
               --dry-run=client --from-file=client-template.json=/dev/stdin -o json | \
                kubeseal | yq eval -P > druid-client-secret.yaml
