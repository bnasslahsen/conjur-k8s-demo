#!/bin/bash

set -a
source .env
set +a

kubectl config set-context --current --namespace=${APP_NAMESPACE}

# DB SECRETS
kubectl delete secret db-credentials --ignore-not-found=true
kubectl apply -f k8s-secrets.yml

# DEPLOYMENT
sed -e "s|APP_NAMESPACE|${APP_NAMESPACE}|g; s|APP_NAME|${APP_NAME}|g; s|SERVICE_ACCOUNT_NAME|${SERVICE_ACCOUNT_NAME}|g; \
        s|TARGET_PORT|${TARGET_PORT}|g; s|IMAGE_NAME|${IMAGE_NAME}|g" \
        deployment.yml | kubectl replace --force -f -

kubectl get services ${APP_NAME}
kubectl get pods