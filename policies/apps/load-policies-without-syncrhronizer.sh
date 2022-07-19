#!/bin/bash

set -a
source ../../.env
set +a

#Define the application as a Conjur host in policy
envsubst < apps.yml > apps.tmp.yml
conjur policy load -b root -f apps.tmp.yml
rm apps.tmp.yml

# Case of Secrets in Conjur
envsubst < app-secrets.yml > app-secrets.tmp.yml
conjur policy load -b root -f app-secrets.tmp.yml
rm app-secrets.tmp.yml

# Set variables
conjur variable set -i secrets/test-app/url -v jdbc:h2:mem:testdb
conjur variable set -i secrets/test-app/username -v user
conjur variable set -i secrets/test-app/password -v pass
conjur variable set -i secrets/test-app/host-postgres -v "$APP_DB_NAME"."$APP_NAMESPACE".svc.cluster.local
conjur variable set -i secrets/test-app/port-postgres -v 5432
conjur variable set -i secrets/test-app/username-postgres -v "$POSTGRESQL_USER"
conjur variable set -i secrets/test-app/password-postgres -v "$POSTGRESQL_PASSWORD"

