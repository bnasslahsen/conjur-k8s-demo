#!/bin/bash

set -a
source ../.env
set +a

kubectl config set-context --current --namespace="$CONJUR_NAMESPACE"

export TOKEN_SECRET_NAME="$(kubectl get secrets | grep 'authn-k8s-sa.*service-account-token' | head -n1 | awk '{print $1}')"
export SA_TOKEN="$(kubectl get secret "$TOKEN_SECRET_NAME" --output='go-template={{ .data.token }}' | base64 -d)"
export K8S_API_URL="$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}')"
export K8S_CA_CERT="$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 -d)"

conjur variable set -i conjur/authn-k8s/"$SERVICE_ID"/kubernetes/service-account-token -v "$SA_TOKEN"
conjur variable set -i conjur/authn-k8s/"$SERVICE_ID"/kubernetes/api-url -v "$K8S_API_URL"
conjur variable set -i conjur/authn-k8s/"$SERVICE_ID"/kubernetes/ca-cert -v "$K8S_CA_CERT"

#Allowlist the Kubernetes Authenticator in Conjur
#vi /opt/cyberark/dap/config/conjur.yml
#podman exec dap evoke configuration apply
#curl -k https://localhost/info