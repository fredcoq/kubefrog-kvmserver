#! /bin/bash

export REGISTRY_SERVER=https://192.168.1.41:30003/

# Replace `[...]` with the registry username
export REGISTRY_USER=admin

# Replace `[...]` with the registry password
export REGISTRY_PASS=Harbor12345

# Replace `[...]` with the registry email
export REGISTRY_EMAIL=any@email.com

kubectl --namespace shipwright-build \
    create secret \
    docker-registry push-secret \
    --docker-server=$REGISTRY_SERVER \
    --docker-username=$REGISTRY_USER \
    --docker-password=$REGISTRY_PASS \
    --docker-email=$REGISTRY_EMAIL \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee ship-regcred.yaml
