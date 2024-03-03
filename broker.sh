#!/bin/bash -e
#
# This script is used to deploy Snyk Broker to kubernetes
# Usage: gitlab.sh {deploy|destroy}
#
# deploy: Start Snyk Broker to kubernetes
# destoy: delete the Snyk Broker deployment
#
# set the required environment variables
export BROKER_TOKEN=$BROKER_TOKEN
export GITLAB_URL=$GITLAB_URL
export GITLAB_TOKEN=$GITLAB_TOKEN
export BROKER_CLIENT_URL=$BROKER_CLIENT_URL
export BROKER_CLIENT_PORT=$BROKER_CLIENT_PORT

if [ "$1" == "destroy" ]; then
    helm uninstall snyk-broker-chart -n snyk-broker
    kubectl delete namespace snyk-broker
    exit 0
fi

if [ "$1" == "deploy" ]; then
    helm repo add snyk-broker https://snyk.github.io/snyk-broker-helm/ --force-update
    helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=gitlab \
             --set brokerToken=${BROKER_TOKEN} \
             --set gitlab=${GITLAB_URL} \
             --set scmToken=${GITLAB_TOKEN} \
             --set brokerClientUrl=${BROKER_CLIENT_URL}:${BROKER_CLIENT_PORT} \
             -n snyk-broker --create-namespace
    exit 0
fi

