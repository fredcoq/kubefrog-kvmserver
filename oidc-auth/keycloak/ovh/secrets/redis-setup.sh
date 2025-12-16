#!/bin/bash

REDIS_PASS=$(python3 -c 'import secrets; print(secrets.token_hex(10))')
kubectl create secret generic -n auth oauth2-proxy-redis --from-literal=redis-password=${REDIS_PASS} --dry-run=client -o yaml | kubeseal | yq eval -P > redis-secret.yaml


