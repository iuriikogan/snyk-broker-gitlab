#!/bin/bash -ex
#
# This script is used to deploy a gitlab instance into a KinD Cluster
# Usage: gitlab.sh {deploy|destroy}
#
# deploy: deploy a gitlab instance into a KinD Cluster
# destoy: delete the gitlab instance and KinD Cluster
#
# prerequisites:
# - docker - https://docs.docker.com/get-docker/
# - KinD - https://kind.sigs.k8s.io/docs/user/quick-start/
# - kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/
# - helm - https://helm.sh/docs/intro/install/
#
# set the required environment variables
#
export GITLAB_DOMAIN="gitlab.192.168.100.69.nip.io"
export EXTERNAL_IP="192.168.100.69"
export CERT_ISSUER_EMAIL="koganiurii@gmail.com"
export POSTGRES_IMAGE_TAG="13.6.0"

if [ "$1" == "destroy" ]; then
    kind delete cluster --name gitlab
    exit 0
fi

if  [ "$1" == "deploy" ]; then
   
    helm repo add gitlab https://charts.gitlab.io/
    helm repo update
    helm install gitlab gitlab/gitlab \
    --timeout 600s \
    --set global.hosts.domain=${GITLAB_DOMAIN} \
    --set global.hosts.externalIP=${EXTERNAL_IP} \
    --set certmanager-issuer.email=${CERT_ISSUER_EMAIL} \
    --set postgresql.image.tag=${POSTGRES_IMAGE_TAG} \
    -n gitlab --create-namespace
    
fi
