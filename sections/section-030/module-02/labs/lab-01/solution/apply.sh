#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
cd "${LAB_DIR}"

cat <<'YAML' > web-pod-patched.yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  labels:
    tier: web
    managed-by: kyverno
spec:
  containers:
    - name: app
      image: nginx:1.25-alpine
YAML

cat <<'YAML' > default-deny-generated.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: team-a
spec:
  podSelector: {}
  policyTypes:
    - Ingress
YAML

cat <<'YAML' > kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: mutate-and-generate-tests
policies:
  - add-managed-by.yaml
  - add-default-deny.yaml
resources:
  - web-pod.yaml
  - batch-pod.yaml
  - team-a-namespace.yaml
results:
  - policy: add-managed-by
    rule: set-managed-by
    resources:
      - web-pod
    kind: Pod
    patchedResources: web-pod-patched.yaml
    result: pass
  - policy: add-managed-by
    rule: set-managed-by
    resources:
      - batch-pod
    kind: Pod
    result: skip
  - policy: add-default-deny
    rule: create-default-deny
    resources:
      - team-a
    kind: Namespace
    generatedResource: default-deny-generated.yaml
    result: pass
YAML
echo "[solution] expected files and kyverno-test.yaml written."
