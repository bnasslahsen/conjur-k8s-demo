#!/bin/bash

#Define the application as a Conjur host in policy
conjur policy load -f apps.yml -b root

# Case of Secrets synchronized from the Vault
conjur policy load -f safe-access.yml -b root

# Case of Secrets in Conjur
conjur policy load -f app-secrets.yml -b root