#! /bin/bash
export INFISICAL_DISABLE_UPDATE_CHECK=true
export GH_TOKEN=$(infisical secrets get REPO_FREDCOQ_TOKEN --path /ARGOCD/GITHUB_TOKEN --silent --plain)
echo $GH_TOKEN
