# #!/bin/bash
# OIDC_CLIENT_ID=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
OIDC_CLIENT_ID="openweui-ID"
OIDC_CLIENT_SECRET=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

yq eval -j -P ".clientId = \"${OIDC_CLIENT_ID}\" | .name = \"openwebui\" | .secret = \"${OIDC_CLIENT_SECRET}\" | \
               .redirectUris[0] = \"https://ollama-webui.kubefrog.fr/oauth/oidc/callback\" \
               " client-template.json | kubectl create secret generic -n ollama openwebui-client  \
               --dry-run=client --from-file=client-template.json=/dev/stdin -o json | \
                kubeseal | yq eval -P > openwebui-client-secret.yaml




