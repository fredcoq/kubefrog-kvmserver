#! /bin/bash

kubectl port-forward -n argocd svc/argocd-server 8087:80 > /dev/null
sleep 2
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd login localhost:8087 --name argocd --username admin  --password $PASS
argocd account update-password --account admin --current-password $PASS --new-password Fred_271987
