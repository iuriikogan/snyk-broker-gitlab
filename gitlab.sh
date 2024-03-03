#!/bin/bash -e
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
export GITLAB_DOMAIN="192.168.100.69.nip.io"
export EXTERNAL_IP=192.168.100.69
export CERT_ISSUER_EMAIL="koganiurii@gmail.com"
export POSTGRES_IMAGE_TAG="13.6.0"

if [ "$1" == "destroy" ]; then
    helm uninstall gitlab -n gitlab
    kubectl delete namespace gitlab
    exit 0
fi

if  [ "$1" == "deploy" ]; then
   
    helm repo add gitlab https://charts.gitlab.io/
    helm repo update
    helm install gitlab gitlab/gitlab \
    --timeout 600s \
    --set global.hosts.domain=${GITLAB_DOMAIN} \
    --set certmanager-issuer.email=${CERT_ISSUER_EMAIL} \
    --set postgresql.image.tag=${POSTGRES_IMAGE_TAG} \
    -n gitlab --create-namespace

    echo "Gitlab can be accessed here: https://${GITLAB_DOMAIN}"
    echo "Initial root user password:"
    kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo
    exit 0
fi
