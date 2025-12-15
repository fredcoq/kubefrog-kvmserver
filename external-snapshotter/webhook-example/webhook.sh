#! /bin/bash

./create-cert.sh --service snapshot-validation-service --secret snapshot-validation-secret --namespace kube-system
cat ./admission-configuration-template | ./patch-ca-bundle.sh > ./admission-configuration.yaml

kubectl apply -f webhook.yaml
kubectl apply -f admission-configuration.yaml

