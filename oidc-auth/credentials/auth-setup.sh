#!/bin/bash

COOKIE_SECRET=$(python3 -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(16)).decode())')
OIDC_CLIENT_ID=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
OIDC_CLIENT_SECRET=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

OIDC_CLIENT_ID_1=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
OIDC_CLIENT_SECRET_1=$(python3 -c 'import secrets; print(secrets.token_hex(32))')

kubectl create secret generic -n auth oauth2-proxy --from-literal=client-id=${OIDC_CLIENT_ID} --from-literal=client-secret=${OIDC_CLIENT_SECRET} --from-literal=cookie-secret=${COOKIE_SECRET} --dry-run=client -o yaml | kubeseal | yq eval -P > oauth2-proxy-secret.yaml

DATABASE_PASS=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
POSTGRESQL_PASS=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
REDIS_PASS=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
#read -p 'Keycloak Admin Password (not for Kubeflow sign in): ' KEYCLOAK_ADMIN_PASS
#read -p 'Keycloak Management Password (not for Kubeflow sign in): ' KEYCLOAK_MANAGEMENT_PASS
KEYCLOAK_ADMIN_PASS=Fred_271987
KEYCLOAK_MANAGEMENT_PASS=Fred_271987

kubectl create secret generic -n auth keycloak-secret --from-literal=password=${KEYCLOAK_ADMIN_PASS} --from-literal=username=admin --dry-run=client -o yaml | kubeseal | yq eval -P > keycloak-secret.yaml

kubectl create secret generic -n auth keycloak-postgresql --from-literal=password=${DATABASE_PASS} --from-literal=postgres-password=${POSTGRESQL_PASS} --dry-run=client -o yaml | kubeseal | yq eval -P > postgresql-secret.yaml

kubectl create secret generic -n auth oauth2-proxy-redis --from-literal=redis-password=${REDIS_PASS} --dry-run=client -o yaml | kubeseal | yq eval -P > redis-secret.yaml

#read -p 'Email (for Kubeflow login): ' EMAIL
#read -p 'First name (for Kubeflow account): ' FIRSTNAME
#read -p 'Last name (for Kubeflow account): ' LASTNAME
#read -p 'Username (for Kubeflow login): ' USERNAME
#read -p 'Password (for Kubeflow login): ' ADMIN_PASS
EMAIL=frederik.coquelet@gmail.com
FIRSTNAME=frederik
LASTNAME=coquelet
USERNAME=frederik
ADMIN_PASS=12341234



yq eval -j -P ".users[0].username = \"${USERNAME}\" | .users[0].email = \"${EMAIL}\" | .users[0].firstName = \"${FIRSTNAME}\" | .users[0].lastName = \"${LASTNAME}\" | .users[0].credentials[0].value = \"${ADMIN_PASS}\" | \
               .clients[0].clientId = \"${OIDC_CLIENT_ID}\" | .clients[0].secret = \"${OIDC_CLIENT_SECRET}\" | \
               .clients[1].clientId = \"${OIDC_CLIENT_ID_1}\" | .clients[1].secret = \"${OIDC_CLIENT_SECRET_1}\"" kubeflow-realm-template.json | kubectl create secret generic -n auth kubeflow-realm --dry-run=client --from-file=kubeflow-realm.json=/dev/stdin -o json | kubeseal | yq eval -P > kubeflow-realm-secret.yaml

yq eval -j -P ".web.client_id = \"${OIDC_CLIENT_ID_1}\" | .web.client_secret = \"${OIDC_CLIENT_SECRET_1}\" \
               " superset-client-template.json | kubectl create secret generic -n superset superset-oidc-keycloak-config  --dry-run=client --from-file=superset-client.json=/dev/stdin -o json | kubeseal | yq eval -P > superset-client-secret.yaml
