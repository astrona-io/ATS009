#!/usr/bin/env bash
set -eu

# The cluster has no Kyverno controller on purpose: the CLI does the rule work.
kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

mkdir -p /root/apply-mutate

cat <<'YAML' > /root/apply-mutate/legacy-app.yaml
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

cat <<'YAML' > /root/apply-mutate/compliant-app.yaml
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

cat <<'YAML' > /root/apply-mutate/mars.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mars
YAML

echo "Playground ready: the kyverno CLI is installed and the example resources are in /root/apply-mutate."
