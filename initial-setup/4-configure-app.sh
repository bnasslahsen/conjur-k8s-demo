#!/bin/bash

set -a
source .env
set +a

helm repo add cyberark https://cyberark.github.io/helm-charts

kubectl delete namespace ${APP_NAMESPACE} --ignore-not-found=true
kubectl create namespace ${APP_NAMESPACE}

helm install namespace-prep cyberark/conjur-config-namespace-prep \
  --namespace test-app-namespace \
  --set authnK8s.goldenConfigMap="conjur-configmap" \
  --set authnK8s.namespace="cyberark-conjur"

kubectl config set-context --current --namespace=${APP_NAMESPACE}

kubectl create serviceaccount test-app-sa