#!/bin/bash

set -a
source ../.env
set +a

kubectl config set-context --current --namespace="$CONJUR_NAMESPACE"

envsubst < service-account-role.yml | kubectl replace --force -f -

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_SSL_CERTIFICATE"

kubectl delete configmap follower-cm --ignore-not-found=true
kubectl create configmap follower-cm \
  --from-literal CONJUR_ACCOUNT="$CONJUR_ACCOUNT" \
  --from-literal CONJUR_APPLIANCE_URL="$CONJUR_APPLIANCE_URL" \
  --from-literal CONJUR_SEED_FILE_URL="$CONJUR_SEED_FILE_URL" \
  --from-literal AUTHENTICATOR_ID="$SERVICE_ID" \
  --from-file "CONJUR_SSL_CERTIFICATE=$CONJUR_SSL_CERTIFICATE"

#kubectl create secret docker-registry ocirsecret --docker-server=docker.io --docker-username=bnasslahsen --docker-password=
# --docker-email=badr.nasslahsen@gmail.com -n bnl-cyberark-conjur

envsubst < follower-deployment.yml | kubectl replace --force -f -

rm "$CONJUR_SSL_CERTIFICATE"