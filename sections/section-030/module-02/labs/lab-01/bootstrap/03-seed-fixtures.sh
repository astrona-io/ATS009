#!/usr/bin/env bash
# Seeds ~/kyverno-cli-lab with a mutate policy, a generate policy and their input
# resources. No kyverno-test.yaml and no expected-output files: the learner writes them.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
mkdir -p "${LAB_DIR}"
cd "${LAB_DIR}"

cat <<'YAML' > add-managed-by.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-managed-by
spec:
  background: false
  rules:
    - name: set-managed-by
      match:
        any:
          - resources:
              kinds:
                - Pod
              selector:
                matchLabels:
                  tier: web
      mutate:
        patchStrategicMerge:
          metadata:
            labels:
              managed-by: kyverno
YAML

cat <<'YAML' > web-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  labels:
    tier: web
spec:
  containers:
    - name: app
      image: nginx:1.25-alpine
YAML

cat <<'YAML' > batch-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: batch-pod
  labels:
    tier: batch
spec:
  containers:
    - name: app
      image: busybox:1.36
YAML

cat <<'YAML' > add-default-deny.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-default-deny
spec:
  rules:
    - name: create-default-deny
      match:
        any:
          - resources:
              kinds:
                - Namespace
      generate:
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        name: default-deny
        namespace: "{{request.object.metadata.name}}"
        synchronize: true
        data:
          spec:
            podSelector: {}
            policyTypes:
              - Ingress
YAML

cat <<'YAML' > team-a-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: team-a
YAML

echo "Lab fixtures written to ${LAB_DIR}"
