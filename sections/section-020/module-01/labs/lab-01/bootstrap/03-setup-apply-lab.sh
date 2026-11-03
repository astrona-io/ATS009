#!/usr/bin/env bash
set -eu

kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

# Two Pods created directly (no policy enforcing yet), so both are admitted as-is.
cat <<'EOF' | kubectl apply -f -
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
EOF

kubectl -n apps wait --for=condition=Ready pod/compliant-app --timeout=90s
kubectl -n apps wait --for=condition=Ready pod/legacy-app --timeout=90s

mkdir -p /root/apply-lab
cat <<'EOF' > /root/apply-lab/policy.yaml
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
EOF

cat <<'EOF' > /root/apply-lab/compliant-app.yaml
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
EOF

cat <<'EOF' > /root/apply-lab/legacy-app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
  namespace: apps
spec:
  containers:
    - name: app
      image: nginx:alpine
EOF

echo "apply-lab fixtures ready in /root/apply-lab; compliant-app and legacy-app are live in the apps namespace."
