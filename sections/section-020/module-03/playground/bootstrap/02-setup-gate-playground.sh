#!/usr/bin/env bash
set -eu

# The cluster has no Kyverno controller on purpose: the CLI does the rule work.
kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

mkdir -p /root/apply-gate

cat <<'YAML' > /root/apply-gate/legacy-app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
  namespace: apps
spec:
  containers:
    - name: app
      image: nginx:alpine
YAML

cat <<'YAML' > /root/apply-gate/compliant-app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: compliant-app
  namespace: apps
  labels:
    team: checkout
spec:
  containers:
    - name: app
      image: nginx:alpine
YAML

echo "Playground ready: the kyverno CLI is installed and the example Pods are in /root/apply-gate."
