# GitHub organization or the username
export GH_ORG=fredcoq

# ase host accessible through NGINX Ingress
export BASE_HOST=kubefrog.fr # e.g., $INGRESS_HOST.nip.io
# private registry url
export REGISTRY_SERVER=https://core.harbor.kubefrog.fr

# registry username
export REGISTRY_USER=admin

# registry password
export REGISTRY_PASS=Harbor12345

# registry email
export REGISTRY_EMAIL=frederik.coquelet@gmail.com

# GitHub email
export GH_EMAIL=fredcoq@github.com

export HB_USER=admin

export HB_PASSWORD=Harbor12345

export CLOUDFLARE_API_TOKEN=9svkHfGR06VEB0eOaH_cOkG6gKtWIyIoZ_0-teJo
# Wait for a while and repeat the previous command if the output contains `cannot fetch certificate` error message

kubectl --namespace workflows create secret generic regcred  \
        --from-file=./config.json  \
        --dry-run=client \
        --output json \
    | kubeseal --format yaml \
    | tee argo-workflows/overlays/production/regcred.yaml

#----------------------argo events/workflow github and registry credentials
# -----------argocd harbor credentials
echo "apiVersion: v1
kind: Secret
metadata:
  name: harbor-access
  namespace: argocd
type: Opaque
data:
  HTTPS_PASSWORD: $(echo -n $HB_PASSWORD | base64)
  HTTPS_USERNAME: $(echo -n $HB_USER | base64)" \
    | kubeseal --format yaml \
    | tee argocd/harborcred.yaml

# airflow github credentials

kubectl --namespace airflow create secret generic regcred  \
        --from-file=./config.json  \
        --dry-run=client \
        --output json \
    | kubeseal --format yaml \
    | tee airflow-secret/regcred.yaml


