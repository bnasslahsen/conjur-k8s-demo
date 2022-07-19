#!/bin/bash

set -a
source ../../.env
set +a

kubectl config set-context --current --namespace="$APP_NAMESPACE"

# DB SECRETS
kubectl replace -f k8s-secrets.yml --force

# DEPLOYMENT
envsubst < deployment.yml | kubectl replace --force -f -
if ! kubectl wait deployment "$APP_NAME" --for condition=Available=True --timeout=90s
  then exit 1
fi

kubectl get services "$APP_NAME"
kubectl get pods