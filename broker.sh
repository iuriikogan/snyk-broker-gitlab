#!/bin/bash -e
#
# This script is used to deploy Snyk Broker to kubernetes
# Usage: gitlab.sh {deploy|destroy}
#
# deploy: Start Snyk Broker to kubernetes
# destoy: delete the Snyk Broker deployment
#
# curl the broker token from the Snyk API
# 
# curl --include \
#     --request POST \
#     --header "Content-Type: application/json" \
#     --header "Authorization: ${SNYK_TOKEN}" \
#   'https://api.snyk.io/v1/org/${SNYK_ORG}'/integrations/'${INTEGRATION_ID}'/authentication/provision-token'


# set the required environment variables before running this script
export BROKER_TOKEN=$BROKER_TOKEN
export GITHUB_URL=$GITHUB_URL
export GITHUB_TOKEN=$GITHUB_TOKEN
export BROKER_CLIENT_URL=http://192.168.100.6.nip.io
export BROKER_CLIENT_PORT=8080

    helm repo add snyk-broker https://snyk.github.io/snyk-broker-helm/
    helm repo update
    helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=github \
             --set brokerToken=${BROKER_TOKEN} \
             --set gitlab=${GITHUB_URL} \
             --set scmToken=${GITLAB_TOKEN} \
             --set brokerClientUrl=${BROKER_CLIENT_URL}:${BROKER_CLIENT_PORT} \
             -n snyk-broker --create-namespace

# Run in Docker
    docker run --restart=always -d -p 8080:8080 \
        -e BROKER_TOKEN=${BROKER_TOKEN} \
        -e GITHUB_TOKEN=${GITHUB_TOKEN} \
        -e PORT=8000 \
        -e BROKER_CLIENT_URL=http://broker.192.168.100.6.nip.io \
        -e ACCEPT_IAC=tf,yaml,yml,json,tpl \
        -e ACCEPT_CODE=true \
        snyk/broker:github-com