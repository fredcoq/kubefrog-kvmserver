#! /bin/bash

#kubectl get configmap kube-proxy -n kube-system -o yaml | \
#sed -e "s/strictARP: false/strictARP: true/" | \
#kubectl apply -f - -n kube-system

#kustomize build --enable-helm ../openebs | kubectl apply -f -

kustomize build ../sealed-secrets | kubectl apply -f -
# kubectl create namespace rook-ceph
kustomize build --enable-helm ../rook-ceph | kubectl apply -n rook-ceph --server-side=true -f -
sleep 10
kustomize build --enable-helm ../rook-ceph | kubectl apply -n rook-ceph --server-side=true -f -
kustomize build --enable-helm ../argocd | kubectl apply --server-side=true -f -