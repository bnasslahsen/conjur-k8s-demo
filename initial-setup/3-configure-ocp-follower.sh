#!/bin/bash

set -a
source ../.env
set +a

kubectl config set-context --current --namespace="${CONJUR_NAMESPACE}"

envsubst < service-account-role.yml | kubectl replace --force -f -
