#!/usr/bin/env bash
# Seeds ~/kyverno-cli-lab with a policy, two resources, and a kyverno-test.yaml
# that has an incorrect assertion for the learner to diagnose and fix.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
mkdir -p "${LAB_DIR}"
cd "${LAB_DIR}"

cat <<'EOF' > require-run-as-nonroot.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-run-as-nonroot
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: check-runAsNonRoot
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: "spec.securityContext.runAsNonRoot must be set to true."
        pattern:
          spec:
            securityContext:
              runAsNonRoot: true
EOF

cat <<'EOF' > good-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: good-pod
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      image: nginx:alpine
EOF

cat <<'EOF' > bad-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod
spec:
  containers:
    - name: app
      image: nginx:alpine
EOF

# BROKEN: both resources are asserted "pass" under one results entry, but
# bad-pod has no spec.securityContext.runAsNonRoot and will actually fail
# the policy. The learner must fix this file so it truthfully reflects
# Kyverno's real evaluation of each resource.
cat <<'EOF' > kyverno-test.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: Test
metadata:
  name: policy-tests
policies:
  - require-run-as-nonroot.yaml
resources:
  - good-pod.yaml
  - bad-pod.yaml
results:
  - policy: require-run-as-nonroot
    rule: check-runAsNonRoot
    resources:
      - good-pod
      - bad-pod
    kind: Pod
    result: pass
EOF

echo "Lab fixtures written to ${LAB_DIR}"
