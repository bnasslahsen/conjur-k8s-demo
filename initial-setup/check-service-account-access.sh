#!/bin/bash

cli=kubectl
conjur_namespace_name=bnl-cyberark-conjur

# use a cap-d for decoding on macs
if [[ "$(uname -s)" == "linux" ]]; then
  base64d="base64 -d"
else
  base64d="base64 -d"
fi

token_secret_name="$($cli get secrets -n $conjur_namespace_name \
    | grep 'authn-k8s-sa.*service-account-token' \
    | head -n1 \
    | awk '{print $1}')"

cert="$($cli get secret -n $conjur_namespace_name $token_secret_name -o json \
      | jq -r '.data["ca.crt"]' \
      | $base64d)"
token="$($cli get secret -n $conjur_namespace_name $token_secret_name -o json \
      | jq -r .data.token \
      | $base64d)"

api="$($cli config view --minify -o yaml | grep server | awk '{print $2}')"

echo "$cert" > k8s.crt
if [[ "$(curl -s --cacert k8s.crt --header "authorization: bearer ${token}" $api/healthz)" == "ok" ]]; then
  echo "service account access to k8s api verified."
else
  echo
  echo ">>> service account access to k8s api not verified. <<<"
  echo
fi
rm k8s.crt