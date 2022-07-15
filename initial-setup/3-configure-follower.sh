#!/bin/bash

set -a
source .env
set +a

kubectl config set-context --current --namespace=${CONJUR_NAMESPACE}

kubectl replace --force -f service-account-role-binding.yml

openssl s_client -connect ${CONJUR_MASTER_HOSTNAME}:${CONJUR_MASTER_PORT} \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "conjur.pem"

CONJUR_SSL_CERTIFICATE=conjur.pem
CONJUR_APPLIANCE_URL=https://${CONJUR_MASTER_HOSTNAME}
AUTHENTICATOR_ID=dev-cluster
CONJUR_ACCOUNT=devsecops
CONJUR_SEED_FILE_URL=$CONJUR_APPLIANCE_URL/configuration/$CONJUR_ACCOUNT/seed/follower

kubectl delete configmap follower-cm --ignore-not-found=true
kubectl create configmap follower-cm \
  --from-literal CONJUR_ACCOUNT=${CONJUR_ACCOUNT} \
  --from-literal CONJUR_APPLIANCE_URL=${CONJUR_APPLIANCE_URL} \
  --from-literal CONJUR_SEED_FILE_URL=${CONJUR_SEED_FILE_URL} \
  --from-literal AUTHENTICATOR_ID=${AUTHENTICATOR_ID} \
  --from-file "CONJUR_SSL_CERTIFICATE=${CONJUR_SSL_CERTIFICATE}" | kubectl apply -f -

kubectl replace --force -f follower-deployment.yml