#!/usr/bin/env bash
# Writes the policies and resources used in the readings to ~/kyverno-cli-lab.
# No kyverno-test.yaml is written: the learner writes it.
set -eu

LAB_DIR="${HOME}/kyverno-cli-lab"
mkdir -p "${LAB_DIR}"
cd "${LAB_DIR}"

cat <<'YAML' > require-run-as-nonroot.yaml
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
YAML

cat <<'YAML' > good-pod.yaml
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
YAML

cat <<'YAML' > bad-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: bad-pod
spec:
  containers:
    - name: app
      image: nginx:alpine
YAML

cat <<'YAML' > web-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: app
          image: nginx:alpine
YAML

cat <<'YAML' > no-privileged.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: no-privileged
spec:
  validationFailureAction: Enforce
  background: false
  rules:
    - name: check-privileged
      match:
        any:
        - resources:
            kinds:
              - Pod
      validate:
        message: "Privileged containers are not allowed."
        foreach:
          - list: "request.object.spec.containers"
            deny:
              conditions:
                any:
                  - key: "{{ element.securityContext.privileged || `false` }}"
                    operator: Equals
                    value: true
YAML

cat <<'YAML' > privileged-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
spec:
  containers:
    - name: app
      image: nginx:alpine
      securityContext:
        privileged: true
YAML

cat <<'YAML' > calm-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: calm-pod
spec:
  containers:
    - name: app
      image: nginx:alpine
YAML

echo "Playground files written to ${LAB_DIR}"
