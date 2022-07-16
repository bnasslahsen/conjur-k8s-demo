#!/bin/bash

set -a
source .env
set +a

kubectl config set-context --current --namespace="${APP_NAMESPACE}"

# DB SECRETLESS CONFIGMAP
kubectl delete configmap secretless-config --ignore-not-found=true
kubectl create configmap secretless-config --from-file=secretless.yml

# Service account role binding
kubectl delete role secrets-access --ignore-not-found=true
kubectl delete rolebinding test-app-namespace --ignore-not-found=true
kubectl apply -f service-account-role.yml

# DB DEPLOYMENT
sed -e "s|APP_NAMESPACE|${APP_NAMESPACE}|g; s|APP_NAME|${APP_NAME}|g; s|SERVICE_ACCOUNT_NAME|${SERVICE_ACCOUNT_NAME}|g; \
        s|IMAGE_NAME|${IMAGE_NAME}|g; s|HOST_ID|${HOST_ID}|g;
        s|APP_DB_NAME|${APP_DB_NAME}|g; s|POSTGRESQL_DB|${POSTGRESQL_DB}|g; s|POSTGRESQL_USER|${POSTGRESQL_USER}|g; s|POSTGRESQL_PASSWORD|${POSTGRESQL_PASSWORD}|g;" \
        db.yml | kubectl replace --force -f -

if ! kubectl wait deployment "${APP_DB_NAME}" --for condition=Available=True --timeout=90s
  then exit 1
fi

# APP DEPLOYMENT
sed -e "s|APP_NAMESPACE|${APP_NAMESPACE}|g; s|APP_NAME|${APP_NAME}|g; s|SERVICE_ACCOUNT_NAME|${SERVICE_ACCOUNT_NAME}|g; \
        s|IMAGE_NAME|${IMAGE_NAME}|g; s|HOST_ID|${HOST_ID}|g; s|POSTGRESQL_DB|${POSTGRESQL_DB}|g;" \
        deployment.yml | kubectl replace --force -f -

if ! kubectl wait deployment "${APP_NAME}" --for condition=Available=True --timeout=90s
  then exit 1
fi

kubectl get services "${APP_NAME}"
kubectl get pods
