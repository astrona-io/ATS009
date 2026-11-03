#!/usr/bin/env bash
set -eu

# The cluster has no Kyverno controller on purpose: the task is done with the CLI.
kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

mkdir -p /root/mutate-lab
cat <<'YAML' > /root/mutate-lab/mutate-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: default-tier-label
spec:
  rules:
    - name: add-tier
      match:
        any:
        - resources:
            kinds:
              - Pod
      mutate:
        patchStrategicMerge:
          metadata:
            labels:
              +(tier): standard
YAML

cat <<'YAML' > /root/mutate-lab/scout.yaml
apiVersion: v1
kind: Pod
metadata:
  name: scout
  namespace: apps
  labels:
    app: scout
spec:
  containers:
    - name: app
      image: nginx:alpine
YAML

cat <<'YAML' > /root/mutate-lab/generate-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: planet-welcome
spec:
  rules:
    - name: create-welcome-map
      match:
        any:
        - resources:
            kinds:
              - Namespace
      generate:
        apiVersion: v1
        kind: ConfigMap
        name: welcome
        namespace: "{{request.object.metadata.name}}"
        synchronize: true
        data:
          data:
            message: welcome-aboard
YAML

cat <<'YAML' > /root/mutate-lab/venus.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: venus
YAML

cat <<'YAML' > /root/mutate-lab/bridge-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: bridge-access
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: officers-only
      match:
        any:
        - resources:
            kinds:
              - Pod
      exclude:
        any:
        - clusterRoles:
            - bridge-officer
      validate:
        message: "Only bridge officers may change Pods."
        deny: {}
YAML

echo "mutate-lab fixtures ready in /root/mutate-lab; namespace apps exists and has no Pods."
