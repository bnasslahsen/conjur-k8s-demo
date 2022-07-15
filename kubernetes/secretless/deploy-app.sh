#!/bin/bash

set -a
source .env
set +a

kubectl config set-context --current --namespace=${APP_NAMESPACE}

# DB SECRETLESS CONFIGMAP
kubectl delete configmap secretless-config --ignore-not-found=true
kubectl create configmap secretless-config --from-file=secretless.yml

# DB DEPLOYMENT
# kubectl replace --force -f db.yml

# APP DEPLOYMENT
sed -e "s|APP_NAMESPACE|${APP_NAMESPACE}|g; s|APP_NAME|${APP_NAME}|g; s|SERVICE_ACCOUNT_NAME|${SERVICE_ACCOUNT_NAME}|g; \
        s|TARGET_PORT|${TARGET_PORT}|g; s|IMAGE_NAME|${IMAGE_NAME}|g; s|HOST_ID|${HOST_ID}|g;" \
        deployment.yml | kubectl replace --force -f -

# Service account role binding
kubectl delete role secrets-access --ignore-not-found=true
kubectl delete rolebinding test-app-namespace --ignore-not-found=true
kubectl apply -f service-account-role.yml

kubectl get services ${APP_NAME}
kubectl get pods

#checks
export URL=$(kubectl describe  service ${APP_NAME} -n=${APP_NAMESPACE} |grep Endpoints | awk '{print $2}' )

echo $URL