#!/bin/bash

#Set up a Kubernetes Authenticator endpoint in Conjur
conjur policy load -f k8s-authenticator-webservice.yml -b root

#Enable the seed generation service
conjur policy load -f seed-generation.yml -b root

SERVICE_ID=dev-cluster
CONJUR_ACCOUNT=devsecops
CONFIG="
[ req ]
distinguished_name = dn
x509_extensions = v3_ca
[ dn ]
[ v3_ca ]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
"

openssl genrsa -out ca.key 2048

openssl req -x509 -new -nodes -key ca.key -sha1 -days 3650 -set_serial 0x0 -out ca.cert \
  -subj "/CN=conjur.authn-k8s.$SERVICE_ID/OU=Conjur Kubernetes CA/O=$CONJUR_ACCOUNT" \
  -config <(echo "$CONFIG")

openssl x509 -in ca.cert -text -noout

conjur variable set -i conjur/authn-k8s/$SERVICE_ID/ca/key -v "$(cat ca.key)"

conjur variable set -i conjur/authn-k8s/$SERVICE_ID/ca/cert -v "$(cat ca.cert)"