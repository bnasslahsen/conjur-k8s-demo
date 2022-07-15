#!/bin/bash

set -a
source .env
set +a

helm repo add cyberark https://cyberark.github.io/helm-charts

helm install cluster-prep cyberark/conjur-config-cluster-prep \
  --namespace cyberark-conjur \
  --create-namespace \
  --set conjur.account="devsecops" \
  --set conjur.applianceUrl="https://conjur-follower.cyberark-conjur.svc.cluster.local" \
  --set conjur.certificateBase64="$(base64 -w0 certs/conjur.pem)" \
  --set authnK8s.authenticatorID="dev-cluster" \
  --set authnK8s.serviceAccount.name="authn-k8s-sa"