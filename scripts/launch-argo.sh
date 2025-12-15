#! /bin/bash

kustomize build argocd/ | kubectl apply -f -
