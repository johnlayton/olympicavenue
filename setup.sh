#!/usr/bin/env bash

set -euf -o pipefail

echo "======================"
echo "Create Kubernetes"
echo "======================"

kenv create minikube olympicavenue

echo "======================"
echo "Install Dashboard"
echo "======================"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.3/aio/deploy/recommended.yaml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

#kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') --output json | jq ".data.token" -r | pbcopy -

open "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/."

echo "======================"
echo "Install Flux"
echo "======================"

kubectl create ns flux

fluxctl install \
--git-user=johnlayton \
--git-email=johnlayton@users.noreply.github.com \
--git-url=git@github.com:johnlayton/olympicavenue \
--git-path=namespaces,workloads \
--namespace=flux | kubectl apply -f -

kubectl -n flux rollout status deployment/flux