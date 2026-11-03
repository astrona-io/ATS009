#!/usr/bin/env bash
set -eu

# The lab folder: one policy and two Pod files. The graded answers (test
# scaffold, user-info file, completion script, reference pages) are not
# written here: the learner creates them.
mkdir -p /root/toolbox-lab

cat <<'EOT' > /root/toolbox-lab/policy.yaml
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

cat <<'EOT' > /root/toolbox-lab/compliant-app.yaml
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

cat <<'EOT' > /root/toolbox-lab/legacy-app.yaml
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

echo "Lab folder ready: /root/toolbox-lab"
