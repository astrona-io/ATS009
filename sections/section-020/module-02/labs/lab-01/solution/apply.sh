#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

cd /root/mutate-lab

rm -f scout-mutated.yaml welcome-generated.yaml
kyverno apply mutate-policy.yaml --resource scout.yaml -o scout-mutated.yaml
kyverno apply generate-policy.yaml --resource venus.yaml -o welcome-generated.yaml

cat <<'YAML' > bridge-officer.yaml
apiVersion: cli.kyverno.io/v1alpha1
kind: UserInfo
clusterRoles:
  - bridge-officer
YAML

kubectl apply -f scout-mutated.yaml
echo "[solution] Applied."
