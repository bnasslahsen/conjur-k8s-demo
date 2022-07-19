#!/bin/bash

set -a
source ../.env
set +a

kubectl config set-context --current --namespace="$CONJUR_NAMESPACE"

export TOKEN_SECRET_NAME="$(oc get secrets | grep 'authn-k8s-sa.*service-account-token' | head -n1 | awk '{print $1}')"
export SA_TOKEN="$(oc get secret "$TOKEN_SECRET_NAME" --output='go-template={{ .data.token }}' | base64 -d)"
export K8S_API_URL="$(oc config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}')"
export K8S_CA_CERT="$(oc get secret -n bnl-cyberark-conjur "$TOKEN_SECRET_NAME" -o json | jq -r '.data["ca.crt"]' | base64 --decode)"

conjur variable set -i conjur/authn-k8s/"$SERVICE_ID"/kubernetes/service-account-token -v "$SA_TOKEN"
conjur variable set -i conjur/authn-k8s/"$SERVICE_ID"/kubernetes/api-url -v "$K8S_API_URL"
conjur variable set -i conjur/authn-k8s/"$SERVICE_ID"/kubernetes/ca-cert -v "$K8S_CA_CERT"

#Allowlist the Kubernetes Authenticator in Conjur
#vi /opt/cyberark/dap/config/conjur.yml
#podman exec dap evoke configuration apply
#curl -k https://localhost/info

openssl s_client -connect "$CONJUR_MASTER_HOSTNAME":"$CONJUR_MASTER_PORT" \
  -showcerts </dev/null 2> /dev/null | \
  awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' \
  > "$CONJUR_SSL_CERTIFICATE"

oc delete configmap conjur-cert --ignore-not-found=true
oc create configmap conjur-cert --from-file=conjur.pem="$CONJUR_SSL_CERTIFICATE"

oc delete configmap conjur-config --ignore-not-found=true
oc create configmap conjur-config --from-file=conjur.yml=conjur.yml

rm "$CONJUR_SSL_CERTIFICATE"