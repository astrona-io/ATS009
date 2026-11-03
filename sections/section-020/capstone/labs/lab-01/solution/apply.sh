#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -eu

cd /root/apply-capstone

kyverno apply policy.yaml --resource good-img.yaml --resource bad-img.yaml -f values.yaml --table > offline-results.txt || true

kubectl apply -f policy.yaml
kubectl wait --for=condition=Ready clusterpolicy/check-registry-cm --timeout=90s || true

kubectl apply -f good-img.yaml
kubectl apply -f bad-img.yaml || true

kyverno apply policy.yaml --cluster --namespace apps --policy-report > cluster-report.yaml || true
echo "[solution] Applied."
