#! /bin/bash

kubectl --namespace kafka \
    create secret generic reg-certs\
    --from-file=ca.crt \
    --dry-run=client \
    --output json \
    | kubeseal --format yaml \
    | tee camel-k-ca.yaml

