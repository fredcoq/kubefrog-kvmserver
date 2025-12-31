#! /bin/bash

export REGISTRY_SERVER=https://harbor-core.kubefrog.fr

# Replace `[...]` with the registry username
export REGISTRY_USER=admin

# Replace `[...]` with the registry password
export REGISTRY_PASS=Harbor12345

# Replace `[...]` with the registry email
export REGISTRY_EMAIL=frederik.coquelet@gmail.com

kubectl --namespace camel-k \
    create secret \
    docker-registry docker-regcred \
    --docker-server=$REGISTRY_SERVER \
    --docker-username=$REGISTRY_USER \
    --docker-password=$REGISTRY_PASS \
    --docker-email=$REGISTRY_EMAIL \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee camel-k/docker-regcred.yaml
