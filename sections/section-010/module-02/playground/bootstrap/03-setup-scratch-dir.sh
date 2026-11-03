#!/usr/bin/env bash
set -eu

# A scratch folder with one policy and two Pod files to point the CLI at.
# No test manifest, values file or other generated file is written here:
# the learner creates those with `kyverno create`.
mkdir -p /root/toolbox

cat <<'EOT' > /root/toolbox/policy.yaml
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
EOT

cat <<'EOT' > /root/toolbox/compliant-app.yaml
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
EOT

cat <<'EOT' > /root/toolbox/legacy-app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
  namespace: apps
spec:
  containers:
    - name: app
      image: nginx:alpine
EOT

echo "Scratch folder ready: /root/toolbox"
