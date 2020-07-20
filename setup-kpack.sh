#!/usr/bin/env bash

set -euf -o pipefail

echo "======================"
echo "Install kpack"
echo "======================"
#kubectl apply -f https://github.com/pivotal/kpack/releases/download/v0.0.9/release-0.0.9.yaml

#kubectl get pods --namespace kpack --watch

#echo "======================"
#echo "Create cluster builder"
#echo "======================"
#cat <<EOF | kubectl apply -f -
#apiVersion: build.pivotal.io/v1alpha1
#kind: ClusterBuilder
#metadata:
#  name: default
#spec:
#  image: gcr.io/paketo-buildpacks/builder:base
#EOF
#
#echo "======================"
#echo "Create docker credentials"
#echo "======================"
#cat <<EOF | kubectl apply -f -
#apiVersion: v1
#kind: Secret
#metadata:
#  name: tutorial-registry-credentials
#  annotations:
#    build.pivotal.io/docker: https://index.docker.io/v1/
#type: kubernetes.io/basic-auth
#stringData:
#  username: ${DOCKERHUB_USERNAME}
#  password: ${DOCKERHUB_PASSWORD}
#EOF
#
#echo "======================"
#echo "Create service account"
#echo "======================"
#cat <<EOF | kubectl apply -f -
#apiVersion: v1
#kind: ServiceAccount
#metadata:
# name: tutorial-service-account
#secrets:
# - name: tutorial-registry-credentials
#EOF

echo "======================"
echo "Create image configuration"
echo "======================"
cat <<EOF | kubectl apply -f -
apiVersion: build.pivotal.io/v1alpha1
kind: Image
metadata:
  name: tutorial-image
spec:
  tag: johnlayton/spring-petclinic
  serviceAccount: tutorial-service-account
  cacheSize: "1.5Gi"
  builder:
    name: default
    kind: ClusterBuilder
  source:
    git:
      url: https://github.com/spring-projects/spring-petclinic
      revision: 82cb521d636b282340378d80a6307a08e3d4a4c4
EOF
