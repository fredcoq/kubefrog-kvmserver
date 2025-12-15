#! /bin/bash

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kustomize build --enable-helm ../openebs | kubectl apply -f -
#kustomize build ../sealed-secrets | kubectl apply -f -
#sleep 5
#kustomize build ../argocd | kubectl apply -f -

