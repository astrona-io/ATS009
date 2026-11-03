#!/usr/bin/env bash
set -eu

kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

# Two Pods created directly (no policy is live), so both are admitted as they are.
cat <<'YAML' | kubectl apply -f -
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
---
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

kubectl -n apps wait --for=condition=Ready pod/compliant-app --timeout=90s
kubectl -n apps wait --for=condition=Ready pod/legacy-app --timeout=90s

mkdir -p /root/apply-lab
cat <<'YAML' > /root/apply-lab/policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-team-label
spec:
  validationFailureAction: Enforce
  background: true
  rules:
    - name: check-team-label
      match:
        any:
        - resources:
            kinds:
              - Pod
            namespaces:
              - apps
      validate:
        message: "A non-empty 'team' label is required on every Pod in apps."
        pattern:
          metadata:
            labels:
              team: "?*"
YAML

cat <<'YAML' > /root/apply-lab/compliant-app.yaml
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

cat <<'YAML' > /root/apply-lab/legacy-app.yaml
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

echo "Playground ready: Pods compliant-app and legacy-app are live in apps; files are in /root/apply-lab. The policy is NOT applied to the cluster yet."
