#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

cd /root/apply-lab

# The policy is not live yet, so this offline run reads files only.
kyverno apply policy.yaml --resource compliant-app.yaml --resource legacy-app.yaml --table > offline-results.txt || true

kubectl apply -f policy.yaml
kubectl wait --for=condition=Ready clusterpolicy/require-team-label --timeout=90s || true

kyverno apply policy.yaml --cluster --namespace apps --policy-report > cluster-report.yaml || true

# The unlabelled Pod must be rejected.
kubectl run new-app --image=nginx:alpine -n apps || true
echo "[solution] Applied."
