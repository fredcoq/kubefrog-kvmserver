# cretae secret from config.json file
kubectl --namespace camel-k create secret generic regcred  \
        --from-file=./config.json  \
        --dry-run=client \
        --output json \
    | kubeseal --format yaml \
    | tee camel-k/regcred.yaml



