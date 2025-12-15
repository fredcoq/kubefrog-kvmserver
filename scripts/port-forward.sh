#! /bin/bash

kubectl port-forward svc/argocd-server -n argocd 8085:443
