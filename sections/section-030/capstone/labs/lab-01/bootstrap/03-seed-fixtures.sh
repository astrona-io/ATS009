#!/usr/bin/env bash
# Seeds ~/kyverno-cli-lab with two policies and four resources.
# No kyverno-test.yaml is provided — the learner writes it from scratch.
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

cat <<'EOF' > disallow-latest-tag.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-latest-tag
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: require-image-tag
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: "An image tag is required."
        pattern:
          spec:
            containers:
              - image: "*:*"
    - name: validate-image-tag
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: "Using a mutable image tag such as 'latest' is not allowed."
        pattern:
          spec:
            containers:
              - image: "!*:latest"
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
      image: nginx:1.25-alpine
EOF

cat <<'EOF' > bad-nonroot-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-nonroot-pod
spec:
  containers:
    - name: app
      image: nginx:1.25-alpine
EOF

cat <<'EOF' > bad-image-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-image-pod
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      image: nginx:latest
EOF

cat <<'EOF' > bad-both-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-both-pod
spec:
  containers:
    - name: app
      image: nginx:latest
EOF

echo "Capstone fixtures written to ${LAB_DIR}"
