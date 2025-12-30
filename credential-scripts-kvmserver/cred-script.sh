# GitHub organization or the username
export GH_ORG=fredcoq

export INFISICAL_TOKEN=$(infisical login --method=user --interactive --domain https://infisical.kubefrog.fr --plain --silent)

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

# GitHub token
export GH_TOKEN=$(infisical secrets get REPO_FREDCOQ_TOKEN --path /ARGOCD/GITHUB_TOKEN --silent --plain)

# GitHub email
export GH_EMAIL=fredcoq@github.com

export HB_USER=admin

export HB_PASSWORD=Harbor12345

export CLOUDFLARE_API_TOKEN=$(infisical secrets get CLOUDFLARE_TOKEN --path /CLOUDFLARE/CLOUDFLARE_KUBEFROG --silent --plain)
# Wait for a while and repeat the previous command if the output contains `cannot fetch certificate` error message

kubectl --namespace workflows create secret generic regcred  \
        --from-file=./config.json  \
        --dry-run=client \
        --output json \
    | kubeseal --format yaml \
    | tee argo-workflows/overlays/production/regcred.yaml

#----------------------argo events/workflow github and registry credentials
echo "apiVersion: v1
kind: Secret
metadata:
  name: github-access
  namespace: workflows
type: Opaque
data:
  token: $(echo -n $GH_TOKEN | base64)
  user: $(echo -n $GH_ORG | base64)
  email: $(echo -n $GH_EMAIL | base64)" \
    | kubeseal --format yaml \
    | tee argo-workflows/overlays/workflows/githubcred.yaml

echo "apiVersion: v1
kind: Secret
metadata:
  name: github-access
  namespace: argo-events
type: Opaque
data:
  token: $(echo -n $GH_TOKEN | base64)" \
    | kubeseal --format yaml \
    | tee argo-events/overlays/production/githubcred.yaml

# -----------argocd github credentials
echo "apiVersion: v1
kind: Secret
metadata:
  name: github-access
  namespace: argocd
type: Opaque
data:
  HTTPS_PASSWORD: $(echo -n $GH_TOKEN | base64)
  HTTPS_USERNAME: $(echo -n $GH_ORG | base64)" \
    | kubeseal --format yaml \
    | tee argocd/githubcred.yaml

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


# airflow github credentials

kubectl --namespace airflow create secret generic regcred  \
        --from-file=./config.json  \
        --dry-run=client \
        --output json \
    | kubeseal --format yaml \
    | tee airflow-secret/regcred.yaml


echo "apiVersion: v1
kind: Secret
metadata:
  name: github-access
  namespace: airflow
type: Opaque
data:
  GIT_SYNC_PASSWORD: $(echo -n $GH_TOKEN | base64)
  GIT_SYNC_USERNAME: $(echo -n fredcoq | base64)" \
    | kubeseal --format yaml \
    | tee airflow-secret/githubcred.yaml

# --------------CLOUDFLARE API KEY

echo "apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-key-secret
  namespace: cert-manager
type: Opaque
stringData:
  api-token: $(echo -n $CLOUDFLARE_API_TOKEN)" \
    | kubeseal --format yaml \
    | tee cert-manager/env/local/cloudflare-api-token-secret.yaml

# ---------------GITHUB REPO SECRETS------------
echo "apiVersion: v1
kind: Secret
metadata:
  name: kubefrog-kvmserver-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/fredcoq/kubefrog-kvmserver" \
    | kubeseal --format yaml \
    | tee argocd/kubefrog-kvmserver-secret.yaml

echo "apiVersion: v1
kind: Secret
metadata:
  name: private-repo-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repo-creds
stringData:
  type: git
  url: https://github.com/fredcoq
  password: $(echo -n $GH_TOKEN)
  username: $(echo -n  "fredcoq")" \
    | kubeseal --format yaml \
    | tee argocd/fredcoq-secret.yaml
