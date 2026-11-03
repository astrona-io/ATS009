#!/usr/bin/env bash
set -eu

# The cluster has no Kyverno controller on purpose: the task is done with the CLI.
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

cat <<'YAML' > /root/apply-gate/enforce-policy.yaml
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

cat <<'YAML' > /root/apply-gate/audit-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-team-label-audit
spec:
  validationFailureAction: Audit
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

echo "gate-lab fixtures ready in /root/apply-gate."
