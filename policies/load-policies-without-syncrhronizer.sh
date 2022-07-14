#!/bin/bash

#Define the application as a Conjur host in policy
conjur policy load -f apps.yml -b root

# Case of Secrets in Conjur
conjur policy load -f app-secrets.yml -b root

# Set variables
conjur variable set -i secrets/test-app/url -v jdbc:h2:mem:testdb
conjur variable set -i secrets/test-app/username -v user
conjur variable set -i secrets/test-app/password -v pass