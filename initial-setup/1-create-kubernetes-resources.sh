#!/bin/bash

set -a
source ../.env
set +a

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_SSL_CERTIFICATE"

helm repo add cyberark https://cyberark.github.io/helm-charts

helm install cluster-prep cyberark/conjur-config-cluster-prep \
  --namespace "$CONJUR_NAMESPACE" \
  --create-namespace \
  --set conjur.account="$CONJUR_ACCOUNT" \
  --set conjur.applianceUrl="https://conjur-follower.$CONJUR_NAMESPACE.svc.cluster.local" \
  --set conjur.certificateBase64=$(cat $CONJUR_SSL_CERTIFICATE | base64) \
  --set authnK8s.authenticatorID="$SERVICE_ID" \
  --set authnK8s.serviceAccount.name="$SERVICE_ACCOUNT_NAME"
cle
rm "$CONJUR_SSL_CERTIFICATE"