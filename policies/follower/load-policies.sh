#!/bin/bash

set -a
source ../../.env
set +a

#Load follower policy
envsubst < k8s-follower.yml > k8s-follower.tmp.yml
conjur policy load -b root -f k8s-follower.tmp.yml
rm k8s-follower.tmp.yml