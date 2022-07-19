#!/bin/bash

set -a
source ../../.env
set +a

#Define the application as a Conjur host in policy
envsubst < apps.yml > apps.tmp.yml
conjur policy load -b root -f apps.tmp.yml
rm apps.yml

# Case of Secrets synchronized from the Vault
conjur policy load -f safe-access.yml -b root